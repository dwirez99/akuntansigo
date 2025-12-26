import 'package:flutter_test/flutter_test.dart';
import 'package:akuntansigo/models/kategori.dart';

void main() {
  group('Kategori Model Tests', () {
    test('should create Kategori instance with all fields', () {
      // Arrange & Act
      final kategori = Kategori(
        id: 1,
        namaKategori: 'Gaji',
        deskripsi: 'Pendapatan dari gaji',
      );

      // Assert
      expect(kategori.id, 1);
      expect(kategori.namaKategori, 'Gaji');
      expect(kategori.deskripsi, 'Pendapatan dari gaji');
    });

    test('should create Kategori without id (for new entries)', () {
      // Arrange & Act
      final kategori = Kategori(
        namaKategori: 'Belanja',
        deskripsi: 'Pengeluaran untuk belanja',
      );

      // Assert
      expect(kategori.id, isNull);
      expect(kategori.namaKategori, 'Belanja');
      expect(kategori.deskripsi, 'Pengeluaran untuk belanja');
    });

    test('should convert Kategori to Map correctly', () {
      // Arrange
      final kategori = Kategori(
        id: 1,
        namaKategori: 'Gaji',
        deskripsi: 'Pendapatan dari gaji',
      );

      // Act
      final map = kategori.toMap();

      // Assert
      expect(map['id'], 1);
      expect(map['nama_kategori'], 'Gaji');
      expect(map['deskripsi'], 'Pendapatan dari gaji');
    });

    test('should create Kategori from Map correctly', () {
      // Arrange
      final map = {
        'id': 2,
        'nama_kategori': 'Transportasi',
        'deskripsi': 'Biaya transportasi',
      };

      // Act
      final kategori = Kategori.fromMap(map);

      // Assert
      expect(kategori.id, 2);
      expect(kategori.namaKategori, 'Transportasi');
      expect(kategori.deskripsi, 'Biaya transportasi');
    });

    test('should handle empty deskripsi', () {
      // Arrange & Act
      final kategori = Kategori(id: 3, namaKategori: 'Lainnya', deskripsi: '');

      // Assert
      expect(kategori.deskripsi, '');
    });

    test('should create multiple Kategori instances independently', () {
      // Arrange & Act
      final kategori1 = Kategori(
        id: 1,
        namaKategori: 'Kategori 1',
        deskripsi: 'Deskripsi 1',
      );

      final kategori2 = Kategori(
        id: 2,
        namaKategori: 'Kategori 2',
        deskripsi: 'Deskripsi 2',
      );

      // Assert
      expect(kategori1.id, 1);
      expect(kategori2.id, 2);
      expect(kategori1.namaKategori, 'Kategori 1');
      expect(kategori2.namaKategori, 'Kategori 2');
    });

    test('should correctly serialize and deserialize', () {
      // Arrange
      final original = Kategori(
        id: 5,
        namaKategori: 'Original Kategori',
        deskripsi: 'Test serialization',
      );

      // Act
      final map = original.toMap();
      final deserialized = Kategori.fromMap(map);

      // Assert
      expect(deserialized.id, original.id);
      expect(deserialized.namaKategori, original.namaKategori);
      expect(deserialized.deskripsi, original.deskripsi);
    });

    test('should handle special characters in namaKategori', () {
      // Arrange & Act
      final kategori = Kategori(
        id: 10,
        namaKategori: 'Gaji & Bonus',
        deskripsi: 'Pendapatan dari gaji dan bonus',
      );

      // Assert
      expect(kategori.namaKategori, 'Gaji & Bonus');
    });

    test('should handle long deskripsi', () {
      // Arrange
      final longDeskripsi =
          'Ini adalah deskripsi yang sangat panjang untuk menguji apakah model dapat menangani teks yang panjang tanpa masalah';

      // Act
      final kategori = Kategori(
        id: 11,
        namaKategori: 'Test',
        deskripsi: longDeskripsi,
      );

      // Assert
      expect(kategori.deskripsi, longDeskripsi);
      expect(kategori.deskripsi?.length, greaterThan(50));
    });
  });
}
