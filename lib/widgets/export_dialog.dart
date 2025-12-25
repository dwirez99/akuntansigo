import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/transaksi.dart';
import '../models/kategori.dart';
import '../core/export/excel_exporter.dart';
import '../core/export/export_helper.dart';

class ExportDialog extends ConsumerStatefulWidget {
  final List<Transaksi> transaksiList;
  final List<Kategori> kategoriList;

  const ExportDialog({
    required this.transaksiList,
    required this.kategoriList,
    super.key,
  });

  @override
  ConsumerState<ExportDialog> createState() => _ExportDialogState();
}

class _ExportDialogState extends ConsumerState<ExportDialog> {
  String _exportFormat = 'excel'; // excel, csv, pdf
  String _dateRange = 'all'; // all, thisMonth, custom
  DateTime? _startDate;
  DateTime? _endDate;
  bool _includePemasukan = true;
  bool _includePengeluaran = true;
  int? _selectedKategoriId;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    // Set default untuk bulan ini
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, 1);
    _endDate = DateTime(now.year, now.month + 1, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  const Icon(Icons.file_download, color: Colors.blue, size: 28),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Export Data Transaksi',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(height: 24),

              // Format File
              const Text(
                'Format File:',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 8),
              _buildFormatSelector(),
              const SizedBox(height: 20),

              // Rentang Waktu
              const Text(
                'Rentang Waktu:',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 8),
              _buildDateRangeSelector(),
              const SizedBox(height: 20),

              // Filter Jenis
              const Text(
                'Jenis Transaksi:',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 8),
              _buildJenisFilter(),
              const SizedBox(height: 20),

              // Filter Kategori
              const Text(
                'Filter Kategori:',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 8),
              _buildKategoriFilter(),
              const SizedBox(height: 24),

              // Info
              _buildInfoCard(),
              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed:
                          _isExporting ? null : () => Navigator.pop(context),
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _isExporting ? null : _handleExport,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child:
                          _isExporting
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                              : const Text(
                                'Export Sekarang',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormatSelector() {
    return Row(
      children: [
        Expanded(
          child: _buildFormatOption(
            icon: Icons.table_chart,
            label: 'Excel',
            value: 'excel',
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildFormatOption(
            icon: Icons.description,
            label: 'CSV',
            value: 'csv',
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildFormatOption(
            icon: Icons.picture_as_pdf,
            label: 'PDF',
            value: 'pdf',
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildFormatOption({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    final isSelected = _exportFormat == value;
    return InkWell(
      onTap: () => setState(() => _exportFormat = value),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? color : Colors.grey.shade600),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? color : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRangeSelector() {
    return Column(
      children: [
        RadioListTile<String>(
          title: const Text('Semua Data'),
          value: 'all',
          groupValue: _dateRange,
          onChanged: (value) => setState(() => _dateRange = value!),
          contentPadding: EdgeInsets.zero,
          dense: true,
        ),
        RadioListTile<String>(
          title: const Text('Bulan Ini'),
          value: 'thisMonth',
          groupValue: _dateRange,
          onChanged: (value) {
            setState(() {
              _dateRange = value!;
              final now = DateTime.now();
              _startDate = DateTime(now.year, now.month, 1);
              _endDate = DateTime(now.year, now.month + 1, 0);
            });
          },
          contentPadding: EdgeInsets.zero,
          dense: true,
        ),
        RadioListTile<String>(
          title: const Text('Pilih Rentang'),
          value: 'custom',
          groupValue: _dateRange,
          onChanged: (value) => setState(() => _dateRange = value!),
          contentPadding: EdgeInsets.zero,
          dense: true,
        ),
        if (_dateRange == 'custom') _buildCustomDateRange(),
      ],
    );
  }

  Widget _buildCustomDateRange() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 8),
      child: Row(
        children: [
          Expanded(
            child: _buildDateField(
              label: 'Dari',
              date: _startDate,
              onTap: () => _selectDate(isStart: true),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildDateField(
              label: 'Sampai',
              date: _endDate,
              onTap: () => _selectDate(isStart: false),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                  ),
                  Text(
                    date != null
                        ? DateFormat('dd/MM/yyyy').format(date)
                        : 'Pilih',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJenisFilter() {
    return Row(
      children: [
        Expanded(
          child: CheckboxListTile(
            title: const Text('Pemasukan'),
            value: _includePemasukan,
            onChanged: (value) => setState(() => _includePemasukan = value!),
            contentPadding: EdgeInsets.zero,
            dense: true,
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ),
        Expanded(
          child: CheckboxListTile(
            title: const Text('Pengeluaran'),
            value: _includePengeluaran,
            onChanged: (value) => setState(() => _includePengeluaran = value!),
            contentPadding: EdgeInsets.zero,
            dense: true,
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ),
      ],
    );
  }

  Widget _buildKategoriFilter() {
    return DropdownButtonFormField<int?>(
      value: _selectedKategoriId,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
      hint: const Text('Semua Kategori'),
      items: [
        const DropdownMenuItem<int?>(
          value: null,
          child: Text('Semua Kategori'),
        ),
        ...widget.kategoriList.map(
          (kategori) => DropdownMenuItem<int?>(
            value: kategori.id,
            child: Text(kategori.namaKategori),
          ),
        ),
      ],
      onChanged: (value) => setState(() => _selectedKategoriId = value),
    );
  }

  Widget _buildInfoCard() {
    final filteredData = _getFilteredData();
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${filteredData.length} transaksi akan di-export',
              style: TextStyle(
                color: Colors.blue.shade900,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Transaksi> _getFilteredData() {
    List<Transaksi> filtered = widget.transaksiList;

    // Filter by date range
    if (_dateRange != 'all' && _startDate != null && _endDate != null) {
      filtered =
          filtered.where((t) {
            final tanggal = DateTime.parse(t.tanggal);
            return tanggal.isAfter(
                  _startDate!.subtract(const Duration(days: 1)),
                ) &&
                tanggal.isBefore(_endDate!.add(const Duration(days: 1)));
          }).toList();
    }

    // Filter by jenis
    if (!_includePemasukan || !_includePengeluaran) {
      filtered =
          filtered.where((t) {
            if (_includePemasukan && t.jenis == 'Pemasukan') return true;
            if (_includePengeluaran && t.jenis == 'Pengeluaran') return true;
            return false;
          }).toList();
    }

    // Filter by kategori
    if (_selectedKategoriId != null) {
      filtered =
          filtered.where((t) => t.kategoriId == _selectedKategoriId).toList();
    }

    return filtered;
  }

  Future<void> _selectDate({required bool isStart}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          isStart
              ? (_startDate ?? DateTime.now())
              : (_endDate ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('id', 'ID'),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _handleExport() async {
    final filteredData = _getFilteredData();

    if (filteredData.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak ada data untuk di-export'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    setState(() => _isExporting = true);

    try {
      if (_exportFormat == 'excel') {
        // Request permission if needed
        final hasPermission = await ExportHelper.requestStoragePermission();
        if (!hasPermission) {
          throw Exception('Permission denied');
        }

        // Export to Excel
        final file = await ExcelExporter.exportTransaksi(
          transaksiList: filteredData,
          kategoriList: widget.kategoriList,
          startDate: _dateRange == 'all' ? null : _startDate,
          endDate: _dateRange == 'all' ? null : _endDate,
        );

        if (mounted) {
          Navigator.pop(context);

          // Show success dialog with share option
          _showSuccessDialog(file);
        }
      } else if (_exportFormat == 'csv') {
        // CSV export - to be implemented
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('CSV export akan segera hadir!'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } else if (_exportFormat == 'pdf') {
        // PDF export - to be implemented
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('PDF export akan segera hadir!'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saat export: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  void _showSuccessDialog(dynamic file) {
    final bool canShare = ExportHelper.isShareSupported();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 28),
                SizedBox(width: 12),
                Text('Export Berhasil!'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('File berhasil di-export.'),
                const SizedBox(height: 8),
                Text(
                  'Ukuran: ${ExportHelper.getFileSize(file)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                if (!canShare) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: Colors.blue.shade700,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'File tersimpan di:\n${file.path}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.blue.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tutup'),
              ),
              if (canShare)
                ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      Navigator.pop(context);
                      await ExportHelper.shareFile(file);
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('Bagikan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                )
              else
                ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      Navigator.pop(context);
                      await ExportHelper.openFileLocation(file);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Membuka lokasi file...'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Tidak bisa membuka folder: $e'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.folder_open),
                  label: const Text('Buka Folder'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
            ],
          ),
    );
  }
}
