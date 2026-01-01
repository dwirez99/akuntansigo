import 'package:flutter_test/flutter_test.dart';
import 'package:akuntansigo/models/transaksi.dart';

void main() {
  group('Transaksi Model Tests', () {
    test('should create Transaksi instance with all fields', () {
      // Arrange & Act
      final transaksi = Transaksi(
        id: 1,
        namaTransaksi: 'Gaji Bulanan',
        tanggal: '2024-01-15',
        jenis: 'Pemasukan',
        kategoriId: 1,
        nominal: 5000000,
        keterangan: 'Gaji bulan Januari',
      );

      // Assert
      expect(transaksi.id, 1);
      expect(transaksi.namaTransaksi, 'Gaji Bulanan');
      expect(transaksi.tanggal, '2024-01-15');
      expect(transaksi.jenis, 'Pemasukan');
      expect(transaksi.kategoriId, 1);
      expect(transaksi.nominal, 5000000);
      expect(transaksi.keterangan, 'Gaji bulan Januari');
    });

    test('should create Transaksi without id (for new entries)', () {
      // Arrange & Act
      final transaksi = Transaksi(
        namaTransaksi: 'Belanja Bulanan',
        tanggal: '2024-01-20',
        jenis: 'Pengeluaran',
        kategoriId: 2,
        nominal: 1500000,
        keterangan: 'Belanja kebutuhan sehari-hari',
      );

      // Assert
      expect(transaksi.id, isNull);
      expect(transaksi.namaTransaksi, 'Belanja Bulanan');
    });

    test('should convert Transaksi to Map correctly', () {
      // Arrange
      final transaksi = Transaksi(
        id: 1,
        namaTransaksi: 'Gaji Bulanan',
        tanggal: '2024-01-15',
        jenis: 'Pemasukan',
        kategoriId: 1,
        nominal: 5000000,
        keterangan: 'Gaji bulan Januari',
      );

      // Act
      final map = transaksi.toMap();

      // Assert
      expect(map['id'], 1);
      expect(map['nama_transaksi'], 'Gaji Bulanan');
      expect(map['tanggal'], '2024-01-15');
      expect(map['jenis'], 'Pemasukan');
      expect(map['kategori_id'], 1);
      expect(map['nominal'], 5000000);
      expect(map['keterangan'], 'Gaji bulan Januari');
    });

    test('should create Transaksi from Map correctly', () {
      // Arrange
      final map = {
        'id': 1,
        'nama_transaksi': 'Gaji Bulanan',
        'tanggal': '2024-01-15',
        'jenis': 'Pemasukan',
        'kategori_id': 1,
        'nominal': 5000000,
        'keterangan': 'Gaji bulan Januari',
      };

      // Act
      final transaksi = Transaksi.fromMap(map);

      // Assert
      expect(transaksi.id, 1);
      expect(transaksi.namaTransaksi, 'Gaji Bulanan');
      expect(transaksi.tanggal, '2024-01-15');
      expect(transaksi.jenis, 'Pemasukan');
      expect(transaksi.kategoriId, 1);
      expect(transaksi.nominal, 5000000);
      expect(transaksi.keterangan, 'Gaji bulan Januari');
    });

    test('should handle empty keterangan', () {
      // Arrange & Act
      final transaksi = Transaksi(
        namaTransaksi: 'Test',
        tanggal: '2024-01-01',
        jenis: 'Pemasukan',
        kategoriId: 1,
        nominal: 1000,
        keterangan: '',
      );

      // Assert
      expect(transaksi.keterangan, '');
    });

    test('should create multiple Transaksi instances independently', () {
      // Arrange & Act
      final transaksi1 = Transaksi(
        id: 1,
        namaTransaksi: 'Transaksi 1',
        tanggal: '2024-01-01',
        jenis: 'Pemasukan',
        kategoriId: 1,
        nominal: 1000,
        keterangan: 'Test 1',
      );

      final transaksi2 = Transaksi(
        id: 2,
        namaTransaksi: 'Transaksi 2',
        tanggal: '2024-01-02',
        jenis: 'Pengeluaran',
        kategoriId: 2,
        nominal: 2000,
        keterangan: 'Test 2',
      );

      // Assert
      expect(transaksi1.id, 1);
      expect(transaksi2.id, 2);
      expect(transaksi1.namaTransaksi, 'Transaksi 1');
      expect(transaksi2.namaTransaksi, 'Transaksi 2');
    });

    test('should handle large nominal values', () {
      // Arrange & Act
      final transaksi = Transaksi(
        namaTransaksi: 'Large Transaction',
        tanggal: '2024-01-01',
        jenis: 'Pemasukan',
        kategoriId: 1,
        nominal: 999999999,
        keterangan: 'Very large amount',
      );

      // Assert
      expect(transaksi.nominal, 999999999);
    });

    test('should correctly serialize and deserialize', () {
      // Arrange
      final original = Transaksi(
        id: 5,
        namaTransaksi: 'Original',
        tanggal: '2024-06-15',
        jenis: 'Pengeluaran',
        kategoriId: 3,
        nominal: 75000,
        keterangan: 'Test serialization',
      );

      // Act
      final map = original.toMap();
      final deserialized = Transaksi.fromMap(map);

      // Assert
      expect(deserialized.id, original.id);
      expect(deserialized.namaTransaksi, original.namaTransaksi);
      expect(deserialized.tanggal, original.tanggal);
      expect(deserialized.jenis, original.jenis);
      expect(deserialized.kategoriId, original.kategoriId);
      expect(deserialized.nominal, original.nominal);
      expect(deserialized.keterangan, original.keterangan);
    });
  });
}
