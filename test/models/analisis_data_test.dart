import 'package:flutter_test/flutter_test.dart';
import 'package:akuntansigo/models/analisis_data.dart';

void main() {
  group('AnalisisData Model Tests', () {
    test('should create AnalisisData instance with all fields', () {
      // Arrange
      final kategoriPemasukan = [
        KategoriAnalisis(
          namaKategori: 'Gaji',
          total: 5000000,
          persentase: 100.0,
        ),
      ];

      final kategoriPengeluaran = [
        KategoriAnalisis(
          namaKategori: 'Belanja',
          total: 2000000,
          persentase: 100.0,
        ),
      ];

      final dataBulanan = [
        BulananData(bulan: '2024-01', pemasukan: 5000000, pengeluaran: 2000000),
      ];

      // Act
      final analisisData = AnalisisData(
        totalPemasukan: 5000000,
        totalPengeluaran: 2000000,
        selisih: 3000000,
        kategoriPemasukan: kategoriPemasukan,
        kategoriPengeluaran: kategoriPengeluaran,
        dataBulanan: dataBulanan,
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 1, 31),
        sumberUtama: 'Gaji',
        posTerbesar: 'Belanja',
      );

      // Assert
      expect(analisisData.totalPemasukan, 5000000);
      expect(analisisData.totalPengeluaran, 2000000);
      expect(analisisData.selisih, 3000000);
      expect(analisisData.kategoriPemasukan.length, 1);
      expect(analisisData.kategoriPengeluaran.length, 1);
      expect(analisisData.dataBulanan.length, 1);
      expect(analisisData.startDate, DateTime(2024, 1, 1));
      expect(analisisData.endDate, DateTime(2024, 1, 31));
      expect(analisisData.sumberUtama, 'Gaji');
      expect(analisisData.posTerbesar, 'Belanja');
    });

    test('should create AnalisisData with null optional fields', () {
      // Act
      final analisisData = AnalisisData(
        totalPemasukan: 1000000,
        totalPengeluaran: 500000,
        selisih: 500000,
        kategoriPemasukan: [],
        kategoriPengeluaran: [],
        dataBulanan: [],
      );

      // Assert
      expect(analisisData.startDate, isNull);
      expect(analisisData.endDate, isNull);
      expect(analisisData.sumberUtama, isNull);
      expect(analisisData.posTerbesar, isNull);
      expect(analisisData.riwayatBulanan, isNull);
    });

    test('should calculate correct selisih (surplus)', () {
      // Act
      final analisisData = AnalisisData(
        totalPemasukan: 10000000,
        totalPengeluaran: 7000000,
        selisih: 3000000,
        kategoriPemasukan: [],
        kategoriPengeluaran: [],
        dataBulanan: [],
      );

      // Assert
      expect(analisisData.selisih, 3000000);
      expect(analisisData.selisih, greaterThan(0));
    });

    test('should calculate correct selisih (deficit)', () {
      // Act
      final analisisData = AnalisisData(
        totalPemasukan: 5000000,
        totalPengeluaran: 8000000,
        selisih: -3000000,
        kategoriPemasukan: [],
        kategoriPengeluaran: [],
        dataBulanan: [],
      );

      // Assert
      expect(analisisData.selisih, -3000000);
      expect(analisisData.selisih, lessThan(0));
    });
  });

  group('KategoriAnalisis Model Tests', () {
    test('should create KategoriAnalisis instance', () {
      // Act
      final kategori = KategoriAnalisis(
        namaKategori: 'Gaji',
        total: 5000000,
        persentase: 75.5,
      );

      // Assert
      expect(kategori.namaKategori, 'Gaji');
      expect(kategori.total, 5000000);
      expect(kategori.persentase, 75.5);
    });

    test('should handle percentage correctly', () {
      // Act
      final kategori = KategoriAnalisis(
        namaKategori: 'Test',
        total: 1000000,
        persentase: 100.0,
      );

      // Assert
      expect(kategori.persentase, 100.0);
      expect(kategori.persentase, lessThanOrEqualTo(100.0));
    });

    test('should handle decimal percentages', () {
      // Act
      final kategori = KategoriAnalisis(
        namaKategori: 'Test',
        total: 1234567,
        persentase: 33.33,
      );

      // Assert
      expect(kategori.persentase, closeTo(33.33, 0.01));
    });
  });

  group('BulananData Model Tests', () {
    test('should create BulananData instance', () {
      // Act
      final bulanan = BulananData(
        bulan: '2024-01',
        pemasukan: 5000000,
        pengeluaran: 3000000,
      );

      // Assert
      expect(bulanan.bulan, '2024-01');
      expect(bulanan.pemasukan, 5000000);
      expect(bulanan.pengeluaran, 3000000);
    });

    test('should handle different month formats', () {
      // Act
      final bulanan = BulananData(
        bulan: '2024-12',
        pemasukan: 1000000,
        pengeluaran: 500000,
      );

      // Assert
      expect(bulanan.bulan, '2024-12');
    });

    test('should calculate correct monthly balance', () {
      // Act
      final bulanan = BulananData(
        bulan: '2024-06',
        pemasukan: 10000000,
        pengeluaran: 7500000,
      );

      final selisih = bulanan.pemasukan - bulanan.pengeluaran;

      // Assert
      expect(selisih, 2500000);
    });
  });

  group('RiwayatBulanan Model Tests', () {
    test('should create RiwayatBulanan instance', () {
      // Arrange
      final items = [
        RiwayatItem(
          kategori: 'Gaji',
          total: 5000000,
          persentaseDariJenis: 100.0,
        ),
      ];

      // Act
      final riwayat = RiwayatBulanan(
        bulan: '2024-01',
        jenis: 'Pemasukan',
        items: items,
        total: 5000000,
      );

      // Assert
      expect(riwayat.bulan, '2024-01');
      expect(riwayat.jenis, 'Pemasukan');
      expect(riwayat.items.length, 1);
      expect(riwayat.total, 5000000);
    });

    test('should handle multiple items', () {
      // Arrange
      final items = [
        RiwayatItem(
          kategori: 'Belanja',
          total: 2000000,
          persentaseDariJenis: 66.67,
        ),
        RiwayatItem(
          kategori: 'Transportasi',
          total: 1000000,
          persentaseDariJenis: 33.33,
        ),
      ];

      // Act
      final riwayat = RiwayatBulanan(
        bulan: '2024-02',
        jenis: 'Pengeluaran',
        items: items,
        total: 3000000,
      );

      // Assert
      expect(riwayat.items.length, 2);
      expect(riwayat.total, 3000000);
    });
  });

  group('RiwayatItem Model Tests', () {
    test('should create RiwayatItem instance', () {
      // Act
      final item = RiwayatItem(
        kategori: 'Gaji',
        total: 5000000,
        persentaseDariJenis: 80.0,
      );

      // Assert
      expect(item.kategori, 'Gaji');
      expect(item.total, 5000000);
      expect(item.persentaseDariJenis, 80.0);
    });

    test('should handle percentage calculation', () {
      // Act
      final item = RiwayatItem(
        kategori: 'Test',
        total: 1500000,
        persentaseDariJenis: 25.5,
      );

      // Assert
      expect(item.persentaseDariJenis, closeTo(25.5, 0.1));
    });
  });

  group('Integration Tests', () {
    test('should create complete AnalisisData with all nested models', () {
      // Arrange
      final kategoriPemasukan = [
        KategoriAnalisis(
          namaKategori: 'Gaji',
          total: 8000000,
          persentase: 80.0,
        ),
        KategoriAnalisis(
          namaKategori: 'Bonus',
          total: 2000000,
          persentase: 20.0,
        ),
      ];

      final kategoriPengeluaran = [
        KategoriAnalisis(
          namaKategori: 'Belanja',
          total: 3000000,
          persentase: 50.0,
        ),
        KategoriAnalisis(
          namaKategori: 'Transportasi',
          total: 2000000,
          persentase: 33.33,
        ),
        KategoriAnalisis(
          namaKategori: 'Hiburan',
          total: 1000000,
          persentase: 16.67,
        ),
      ];

      final dataBulanan = [
        BulananData(
          bulan: '2024-01',
          pemasukan: 10000000,
          pengeluaran: 6000000,
        ),
      ];

      final riwayatItems = [
        RiwayatItem(
          kategori: 'Gaji',
          total: 8000000,
          persentaseDariJenis: 80.0,
        ),
        RiwayatItem(
          kategori: 'Bonus',
          total: 2000000,
          persentaseDariJenis: 20.0,
        ),
      ];

      final riwayatBulanan = [
        RiwayatBulanan(
          bulan: '2024-01',
          jenis: 'Pemasukan',
          items: riwayatItems,
          total: 10000000,
        ),
      ];

      // Act
      final analisisData = AnalisisData(
        totalPemasukan: 10000000,
        totalPengeluaran: 6000000,
        selisih: 4000000,
        kategoriPemasukan: kategoriPemasukan,
        kategoriPengeluaran: kategoriPengeluaran,
        dataBulanan: dataBulanan,
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 1, 31),
        sumberUtama: 'Gaji',
        posTerbesar: 'Belanja',
        riwayatBulanan: riwayatBulanan,
      );

      // Assert
      expect(analisisData.kategoriPemasukan.length, 2);
      expect(analisisData.kategoriPengeluaran.length, 3);
      expect(analisisData.dataBulanan.length, 1);
      expect(analisisData.riwayatBulanan?.length, 1);
      expect(analisisData.selisih, 4000000);

      // Verify totals match
      final totalKategoriPemasukan = kategoriPemasukan.fold<int>(
        0,
        (sum, k) => sum + k.total,
      );
      expect(totalKategoriPemasukan, analisisData.totalPemasukan);
    });
  });
}
