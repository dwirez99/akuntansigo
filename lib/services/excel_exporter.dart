import 'dart:io';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import '../../models/transaksi.dart';
import '../../models/kategori.dart';

class ExcelExporter {
  /// Export transaksi ke Excel dengan multiple sheets
  static Future<File> exportTransaksi({
    required List<Transaksi> transaksiList,
    required List<Kategori> kategoriList,
    String? fileName,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    // Create workbook
    final xlsio.Workbook workbook = xlsio.Workbook();

    // Filter transaksi jika ada date range
    List<Transaksi> filteredTransaksi = transaksiList;
    if (startDate != null && endDate != null) {
      filteredTransaksi =
          transaksiList.where((t) {
            final tanggal = DateTime.parse(t.tanggal);
            return tanggal.isAfter(
                  startDate.subtract(const Duration(days: 1)),
                ) &&
                tanggal.isBefore(endDate.add(const Duration(days: 1)));
          }).toList();
    }

    // Pisahkan data berdasarkan jenis
    final pemasukan =
        filteredTransaksi.where((t) => t.jenis == 'Pemasukan').toList();
    final pengeluaran =
        filteredTransaksi.where((t) => t.jenis == 'Pengeluaran').toList();

    // Create sheets
    final xlsio.Worksheet sheetRingkasan = workbook.worksheets[0];
    sheetRingkasan.name = 'Ringkasan';
    final xlsio.Worksheet sheetPemasukan = workbook.worksheets.addWithName(
      'Pemasukan',
    );
    final xlsio.Worksheet sheetPengeluaran = workbook.worksheets.addWithName(
      'Pengeluaran',
    );
    final xlsio.Worksheet sheetSemua = workbook.worksheets.addWithName(
      'Semua Data',
    );

    // Generate each sheet
    _createRingkasanSheet(sheetRingkasan, pemasukan, pengeluaran, kategoriList);
    _createTransaksiSheet(sheetPemasukan, pemasukan, kategoriList, 'Pemasukan');
    _createTransaksiSheet(
      sheetPengeluaran,
      pengeluaran,
      kategoriList,
      'Pengeluaran',
    );
    _createTransaksiSheet(sheetSemua, filteredTransaksi, kategoriList, 'Semua');

    // Save file
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final String timestamp = DateFormat(
      'yyyyMMdd_HHmmss',
    ).format(DateTime.now());
    final String defaultFileName = 'AkuntansiGo_Export_$timestamp.xlsx';
    final String finalFileName = fileName ?? defaultFileName;

    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = '${directory.path}/$finalFileName';
    final File file = File(path);

    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  /// Create Ringkasan sheet
  static void _createRingkasanSheet(
    xlsio.Worksheet sheet,
    List<Transaksi> pemasukan,
    List<Transaksi> pengeluaran,
    List<Kategori> kategoriList,
  ) {
    // Title
    sheet.getRangeByName('A1').setText('RINGKASAN KEUANGAN');
    sheet.getRangeByName('A1').cellStyle.fontSize = 16;
    sheet.getRangeByName('A1').cellStyle.bold = true;
    sheet.getRangeByName('A1:D1').merge();

    // Tanggal export
    sheet.getRangeByName('A2').setText('Tanggal Export:');
    sheet
        .getRangeByName('B2')
        .setText(
          DateFormat('dd MMMM yyyy HH:mm', 'id_ID').format(DateTime.now()),
        );

    // Summary totals
    final int totalPemasukan = pemasukan.fold(0, (sum, t) => sum + t.nominal);
    final int totalPengeluaran = pengeluaran.fold(
      0,
      (sum, t) => sum + t.nominal,
    );
    final int saldo = totalPemasukan - totalPengeluaran;

    sheet.getRangeByName('A4').setText('TOTAL PEMASUKAN');
    sheet.getRangeByName('B4').setNumber(totalPemasukan.toDouble());
    sheet.getRangeByName('B4').numberFormat = '#,##0';
    sheet.getRangeByName('A4').cellStyle.bold = true;
    sheet.getRangeByName('B4').cellStyle.backColor = '#D4EDDA';

    sheet.getRangeByName('A5').setText('TOTAL PENGELUARAN');
    sheet.getRangeByName('B5').setNumber(totalPengeluaran.toDouble());
    sheet.getRangeByName('B5').numberFormat = '#,##0';
    sheet.getRangeByName('A5').cellStyle.bold = true;
    sheet.getRangeByName('B5').cellStyle.backColor = '#F8D7DA';

    sheet.getRangeByName('A6').setText('SALDO');
    sheet.getRangeByName('B6').setNumber(saldo.toDouble());
    sheet.getRangeByName('B6').numberFormat = '#,##0';
    sheet.getRangeByName('A6').cellStyle.bold = true;
    sheet.getRangeByName('B6').cellStyle.bold = true;
    sheet.getRangeByName('B6').cellStyle.backColor =
        saldo >= 0 ? '#D1ECF1' : '#F8D7DA';

    // Jumlah transaksi
    sheet.getRangeByName('A8').setText('Jumlah Transaksi Pemasukan:');
    sheet.getRangeByName('B8').setNumber(pemasukan.length.toDouble());
    sheet.getRangeByName('A9').setText('Jumlah Transaksi Pengeluaran:');
    sheet.getRangeByName('B9').setNumber(pengeluaran.length.toDouble());

    // Analisis per kategori - Pemasukan
    sheet.getRangeByName('A11').setText('ANALISIS PEMASUKAN PER KATEGORI');
    sheet.getRangeByName('A11').cellStyle.bold = true;
    sheet.getRangeByName('A11').cellStyle.fontSize = 12;

    _addKategoriAnalisis(sheet, pemasukan, kategoriList, 12);

    // Analisis per kategori - Pengeluaran
    final startRowPengeluaran = 12 + _getUniqueKategoriCount(pemasukan) + 3;
    sheet
        .getRangeByName('A$startRowPengeluaran')
        .setText('ANALISIS PENGELUARAN PER KATEGORI');
    sheet.getRangeByName('A$startRowPengeluaran').cellStyle.bold = true;
    sheet.getRangeByName('A$startRowPengeluaran').cellStyle.fontSize = 12;

    _addKategoriAnalisis(
      sheet,
      pengeluaran,
      kategoriList,
      startRowPengeluaran + 1,
    );

    // Auto-fit columns
    sheet.autoFitColumn(1);
    sheet.autoFitColumn(2);
    sheet.autoFitColumn(3);
  }

  /// Add kategori analysis to sheet
  static void _addKategoriAnalisis(
    xlsio.Worksheet sheet,
    List<Transaksi> transaksiList,
    List<Kategori> kategoriList,
    int startRow,
  ) {
    // Header
    sheet.getRangeByName('A$startRow').setText('Kategori');
    sheet.getRangeByName('B$startRow').setText('Jumlah');
    sheet.getRangeByName('C$startRow').setText('Total');
    sheet.getRangeByName('D$startRow').setText('Persentase');

    final headerRange = sheet.getRangeByName('A$startRow:D$startRow');
    headerRange.cellStyle.bold = true;
    headerRange.cellStyle.backColor = '#4472C4';
    headerRange.cellStyle.fontColor = '#FFFFFF';

    // Group by kategori
    Map<int, List<Transaksi>> grouped = {};
    for (var transaksi in transaksiList) {
      grouped.putIfAbsent(transaksi.kategoriId, () => []).add(transaksi);
    }

    final totalNominal = transaksiList.fold(0, (sum, t) => sum + t.nominal);
    int row = startRow + 1;

    grouped.forEach((kategoriId, transaksiGroup) {
      final kategori = kategoriList.firstWhere(
        (k) => k.id == kategoriId,
        orElse:
            () =>
                Kategori(id: 0, namaKategori: 'Tidak Diketahui', deskripsi: ''),
      );

      final total = transaksiGroup.fold(0, (sum, t) => sum + t.nominal);
      final persentase = totalNominal > 0 ? (total / totalNominal * 100) : 0;

      sheet.getRangeByName('A$row').setText(kategori.namaKategori);
      sheet.getRangeByName('B$row').setNumber(transaksiGroup.length.toDouble());
      sheet.getRangeByName('C$row').setNumber(total.toDouble());
      sheet.getRangeByName('C$row').numberFormat = '#,##0';
      sheet.getRangeByName('D$row').setNumber(persentase / 100);
      sheet.getRangeByName('D$row').numberFormat = '0.00%';

      row++;
    });
  }

  /// Get unique kategori count
  static int _getUniqueKategoriCount(List<Transaksi> transaksiList) {
    return transaksiList.map((t) => t.kategoriId).toSet().length;
  }

  /// Create Transaksi sheet (Pemasukan/Pengeluaran/Semua)
  static void _createTransaksiSheet(
    xlsio.Worksheet sheet,
    List<Transaksi> transaksiList,
    List<Kategori> kategoriList,
    String jenisLabel,
  ) {
    // Title
    sheet
        .getRangeByName('A1')
        .setText('DATA TRANSAKSI $jenisLabel'.toUpperCase());
    sheet.getRangeByName('A1').cellStyle.fontSize = 14;
    sheet.getRangeByName('A1').cellStyle.bold = true;
    sheet.getRangeByName('A1:F1').merge();

    // Header
    final headers = [
      'No',
      'Tanggal',
      'Nama Transaksi',
      'Kategori',
      'Jenis',
      'Nominal',
      'Keterangan',
    ];
    for (int i = 0; i < headers.length; i++) {
      final cell = sheet.getRangeByIndex(3, i + 1);
      cell.setText(headers[i]);
      cell.cellStyle.bold = true;
      cell.cellStyle.backColor = '#4472C4';
      cell.cellStyle.fontColor = '#FFFFFF';
      cell.cellStyle.hAlign = xlsio.HAlignType.center;
    }

    // Data rows
    int rowIndex = 4;
    for (int i = 0; i < transaksiList.length; i++) {
      final transaksi = transaksiList[i];
      final kategori = kategoriList.firstWhere(
        (k) => k.id == transaksi.kategoriId,
        orElse:
            () =>
                Kategori(id: 0, namaKategori: 'Tidak Diketahui', deskripsi: ''),
      );

      sheet.getRangeByIndex(rowIndex, 1).setNumber((i + 1).toDouble());
      sheet
          .getRangeByIndex(rowIndex, 2)
          .setText(
            DateFormat('dd/MM/yyyy').format(DateTime.parse(transaksi.tanggal)),
          );
      sheet.getRangeByIndex(rowIndex, 3).setText(transaksi.namaTransaksi);
      sheet.getRangeByIndex(rowIndex, 4).setText(kategori.namaKategori);
      sheet.getRangeByIndex(rowIndex, 5).setText(transaksi.jenis);
      sheet
          .getRangeByIndex(rowIndex, 6)
          .setNumber(transaksi.nominal.toDouble());
      sheet.getRangeByIndex(rowIndex, 6).numberFormat = '#,##0';
      sheet.getRangeByIndex(rowIndex, 7).setText(transaksi.keterangan);

      // Color coding based on jenis
      if (transaksi.jenis == 'Pemasukan') {
        sheet.getRangeByIndex(rowIndex, 6).cellStyle.backColor = '#D4EDDA';
      } else {
        sheet.getRangeByIndex(rowIndex, 6).cellStyle.backColor = '#F8D7DA';
      }

      rowIndex++;
    }

    // Total row
    if (transaksiList.isNotEmpty) {
      final totalRow = rowIndex;
      sheet.getRangeByIndex(totalRow, 5).setText('TOTAL:');
      sheet.getRangeByIndex(totalRow, 5).cellStyle.bold = true;
      sheet.getRangeByIndex(totalRow, 5).cellStyle.hAlign =
          xlsio.HAlignType.right;

      final total = transaksiList.fold(0, (sum, t) => sum + t.nominal);
      sheet.getRangeByIndex(totalRow, 6).setNumber(total.toDouble());
      sheet.getRangeByIndex(totalRow, 6).numberFormat = '#,##0';
      sheet.getRangeByIndex(totalRow, 6).cellStyle.bold = true;
      sheet.getRangeByIndex(totalRow, 6).cellStyle.backColor = '#FFD966';
    }

    // Auto-fit columns
    for (int i = 1; i <= 7; i++) {
      sheet.autoFitColumn(i);
    }

    // Freeze header row
    sheet.getRangeByName('A4').freezePanes();
  }

  /// Export kategori data
  static Future<File> exportKategori({
    required List<Kategori> kategoriList,
    String? fileName,
  }) async {
    final xlsio.Workbook workbook = xlsio.Workbook();
    final xlsio.Worksheet sheet = workbook.worksheets[0];
    sheet.name = 'Kategori';

    // Title
    sheet.getRangeByName('A1').setText('DATA KATEGORI');
    sheet.getRangeByName('A1').cellStyle.fontSize = 14;
    sheet.getRangeByName('A1').cellStyle.bold = true;

    // Header
    sheet.getRangeByName('A3').setText('No');
    sheet.getRangeByName('B3').setText('Nama Kategori');
    sheet.getRangeByName('C3').setText('Deskripsi');

    final headerRange = sheet.getRangeByName('A3:C3');
    headerRange.cellStyle.bold = true;
    headerRange.cellStyle.backColor = '#4472C4';
    headerRange.cellStyle.fontColor = '#FFFFFF';

    // Data
    for (int i = 0; i < kategoriList.length; i++) {
      final kategori = kategoriList[i];
      final row = i + 4;

      sheet.getRangeByIndex(row, 1).setNumber((i + 1).toDouble());
      sheet.getRangeByIndex(row, 2).setText(kategori.namaKategori);
      sheet.getRangeByIndex(row, 3).setText(kategori.deskripsi ?? '');
    }

    // Auto-fit
    sheet.autoFitColumn(1);
    sheet.autoFitColumn(2);
    sheet.autoFitColumn(3);

    // Save
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final String timestamp = DateFormat(
      'yyyyMMdd_HHmmss',
    ).format(DateTime.now());
    final String defaultFileName = 'AkuntansiGo_Kategori_$timestamp.xlsx';
    final String finalFileName = fileName ?? defaultFileName;

    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = '${directory.path}/$finalFileName';
    final File file = File(path);

    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}
