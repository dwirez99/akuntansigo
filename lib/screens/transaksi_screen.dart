import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/transaksi.dart';
import '../models/kategori.dart';
import '../providers/transaksi_provider.dart';
import '../providers/kategori_provider.dart';
import 'transaksi_form_screen.dart';
import '../widgets/export_dialog.dart';

class TransaksiScreen extends ConsumerStatefulWidget {
  const TransaksiScreen({super.key});

  @override
  ConsumerState<TransaksiScreen> createState() => _TransaksiScreenState();
}

class _TransaksiScreenState extends ConsumerState<TransaksiScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _sortBy = 'tanggal'; // tanggal, nama, nominal
  bool _isAscending = false; // false = descending (terbaru/terbesar dulu)

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Transaksi> _filterAndSortTransaksi(
    List<Transaksi> transaksiList,
    List<Kategori> kategoriList,
  ) {
    // Filter berdasarkan pencarian
    List<Transaksi> filtered =
        transaksiList.where((transaksi) {
          if (_searchQuery.isEmpty) return true;

          final kategori = kategoriList.firstWhere(
            (k) => k.id == transaksi.kategoriId,
            orElse: () => Kategori(id: 0, namaKategori: '', deskripsi: ''),
          );

          final searchLower = _searchQuery.toLowerCase();
          return transaksi.namaTransaksi.toLowerCase().contains(searchLower) ||
              transaksi.keterangan.toLowerCase().contains(searchLower) ||
              kategori.namaKategori.toLowerCase().contains(searchLower);
        }).toList();

    // Sorting
    filtered.sort((a, b) {
      int comparison = 0;

      switch (_sortBy) {
        case 'tanggal':
          comparison = a.tanggal.compareTo(b.tanggal);
          break;
        case 'nama':
          comparison = a.namaTransaksi.toLowerCase().compareTo(
            b.namaTransaksi.toLowerCase(),
          );
          break;
        case 'nominal':
          comparison = a.nominal.compareTo(b.nominal);
          break;
      }

      return _isAscending ? comparison : -comparison;
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final transaksiList = ref.watch(transaksiProvider);
    final kategoriList = ref.watch(kategoriProvider);
    final filteredList = _filterAndSortTransaksi(transaksiList, kategoriList);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Transaksi'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Export Button
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Export Data',
            onPressed: () => _showExportDialog(context),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            tooltip: 'Urutkan',
            onSelected: (value) {
              setState(() {
                _sortBy = value;
              });
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: 'tanggal',
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 18,
                          color:
                              _sortBy == 'tanggal'
                                  ? Theme.of(context).primaryColor
                                  : null,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Tanggal',
                          style: TextStyle(
                            fontWeight:
                                _sortBy == 'tanggal'
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                            color:
                                _sortBy == 'tanggal'
                                    ? Theme.of(context).primaryColor
                                    : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'nama',
                    child: Row(
                      children: [
                        Icon(
                          Icons.text_fields,
                          size: 18,
                          color:
                              _sortBy == 'nama'
                                  ? Theme.of(context).primaryColor
                                  : null,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Nama',
                          style: TextStyle(
                            fontWeight:
                                _sortBy == 'nama'
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                            color:
                                _sortBy == 'nama'
                                    ? Theme.of(context).primaryColor
                                    : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'nominal',
                    child: Row(
                      children: [
                        Icon(
                          Icons.attach_money,
                          size: 18,
                          color:
                              _sortBy == 'nominal'
                                  ? Theme.of(context).primaryColor
                                  : null,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Nominal',
                          style: TextStyle(
                            fontWeight:
                                _sortBy == 'nominal'
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                            color:
                                _sortBy == 'nominal'
                                    ? Theme.of(context).primaryColor
                                    : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
          ),
          IconButton(
            icon: Icon(
              _isAscending ? Icons.arrow_upward : Icons.arrow_downward,
            ),
            tooltip: _isAscending ? 'Urutan Naik' : 'Urutan Turun',
            onPressed: () {
              setState(() {
                _isAscending = !_isAscending;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari transaksi...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon:
                    _searchQuery.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                            });
                          },
                        )
                        : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Sorting Info
          if (_searchQuery.isNotEmpty || _sortBy != 'tanggal' || _isAscending)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  if (_searchQuery.isNotEmpty)
                    Expanded(
                      child: Text(
                        'Ditemukan ${filteredList.length} transaksi',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ),
                  if (_sortBy != 'tanggal' || _isAscending)
                    Text(
                      'Diurutkan: ${_getSortLabel()} (${_isAscending ? "Naik" : "Turun"})',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
            ),

          // List Transaksi
          Expanded(
            child:
                filteredList.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _searchQuery.isNotEmpty
                                ? Icons.search_off
                                : Icons.receipt_long_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _searchQuery.isNotEmpty
                                ? 'Tidak ada transaksi yang cocok'
                                : 'Belum ada transaksi',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          if (_searchQuery.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                    _searchQuery = '';
                                  });
                                },
                                child: const Text('Hapus Pencarian'),
                              ),
                            ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final transaksi = filteredList[index];
                        final kategori = kategoriList.firstWhere(
                          (k) => k.id == transaksi.kategoriId,
                          orElse:
                              () => Kategori(
                                id: 0,
                                namaKategori: 'Kategori Tidak Ditemukan',
                                deskripsi: '',
                              ),
                        );

                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  transaksi.jenis == 'Pemasukan'
                                      ? Colors.green
                                      : Colors.red,
                              child: Icon(
                                transaksi.jenis == 'Pemasukan'
                                    ? Icons.arrow_upward
                                    : Icons.arrow_downward,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              transaksi.namaTransaksi,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Kategori: ${kategori.namaKategori}'),
                                Text(
                                  DateFormat(
                                    'dd/MM/yyyy',
                                  ).format(DateTime.parse(transaksi.tanggal)),
                                ),
                                if (transaksi.keterangan.isNotEmpty)
                                  Text(
                                    transaksi.keterangan,
                                    style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 12,
                                    ),
                                  ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    _formatCurrency(transaksi.nominal),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          transaksi.jenis == 'Pemasukan'
                                              ? Colors.green
                                              : Colors.red,
                                    ),
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(
                                    minWidth: 140,
                                  ),
                                  onSelected: (value) {
                                    if (value == 'edit') {
                                      _editTransaksi(context, transaksi);
                                    } else if (value == 'delete') {
                                      _showDeleteDialog(
                                        context,
                                        ref,
                                        transaksi,
                                      );
                                    }
                                  },
                                  itemBuilder:
                                      (context) => [
                                        const PopupMenuItem(
                                          value: 'edit',
                                          child: Row(
                                            children: [
                                              Icon(Icons.edit, size: 16),
                                              SizedBox(width: 8),
                                              Text('Edit'),
                                            ],
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          value: 'delete',
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                                size: 16,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                'Hapus',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                ),
                              ],
                            ),
                            isThreeLine: true,
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTransaksi(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  String _getSortLabel() {
    switch (_sortBy) {
      case 'tanggal':
        return 'Tanggal';
      case 'nama':
        return 'Nama';
      case 'nominal':
        return 'Nominal';
      default:
        return 'Tanggal';
    }
  }

  String _formatCurrency(int amount) {
    final formatter = NumberFormat('#,###');
    return 'Rp ${formatter.format(amount)}';
  }

  void _addTransaksi(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TransaksiFormScreen()),
    );
  }

  void _editTransaksi(BuildContext context, Transaksi transaksi) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransaksiFormScreen(transaksi: transaksi),
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    WidgetRef ref,
    Transaksi transaksi,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Hapus Transaksi'),
            content: Text(
              'Yakin ingin menghapus transaksi "${transaksi.namaTransaksi}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ref
                      .read(transaksiProvider.notifier)
                      .deleteTransaksi(transaksi.id!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Transaksi berhasil dihapus'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Hapus'),
              ),
            ],
          ),
    );
  }

  void _showExportDialog(BuildContext context) {
    final transaksiList = ref.read(transaksiProvider);
    final kategoriList = ref.read(kategoriProvider);

    showDialog(
      context: context,
      builder:
          (context) => ExportDialog(
            transaksiList: transaksiList,
            kategoriList: kategoriList,
          ),
    );
  }
}
