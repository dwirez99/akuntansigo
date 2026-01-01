import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:akuntansigo/models/transaksi.dart';
import 'package:akuntansigo/models/kategori.dart';

/// Helper class for creating test data
class TestData {
  /// Creates a sample Kategori for testing
  static Kategori createKategori({
    int? id,
    String? namaKategori,
    String? deskripsi,
  }) {
    return Kategori(
      id: id ?? 1,
      namaKategori: namaKategori ?? 'Test Kategori',
      deskripsi: deskripsi ?? 'Test deskripsi',
    );
  }

  /// Creates a sample Transaksi for testing
  static Transaksi createTransaksi({
    int? id,
    String? namaTransaksi,
    String? tanggal,
    String? jenis,
    int? kategoriId,
    int? nominal,
    String? keterangan,
  }) {
    return Transaksi(
      id: id,
      namaTransaksi: namaTransaksi ?? 'Test Transaksi',
      tanggal: tanggal ?? '2024-01-15',
      jenis: jenis ?? 'Pemasukan',
      kategoriId: kategoriId ?? 1,
      nominal: nominal ?? 1000000,
      keterangan: keterangan ?? 'Test keterangan',
    );
  }

  /// Creates a list of sample Kategori instances
  static List<Kategori> createKategoriList({int count = 3}) {
    return List.generate(
      count,
      (index) => Kategori(
        id: index + 1,
        namaKategori: 'Kategori ${index + 1}',
        deskripsi: 'Deskripsi kategori ${index + 1}',
      ),
    );
  }

  /// Creates a list of sample Transaksi instances
  static List<Transaksi> createTransaksiList({int count = 5, String? jenis}) {
    return List.generate(
      count,
      (index) => Transaksi(
        id: index + 1,
        namaTransaksi: 'Transaksi ${index + 1}',
        tanggal: '2024-01-${(index + 1).toString().padLeft(2, '0')}',
        jenis: jenis ?? (index % 2 == 0 ? 'Pemasukan' : 'Pengeluaran'),
        kategoriId: (index % 3) + 1,
        nominal: (index + 1) * 100000,
        keterangan: 'Keterangan transaksi ${index + 1}',
      ),
    );
  }

  /// Creates a mixed list of Pemasukan and Pengeluaran
  static List<Transaksi> createMixedTransaksiList() {
    return [
      Transaksi(
        id: 1,
        namaTransaksi: 'Gaji Bulanan',
        tanggal: '2024-01-01',
        jenis: 'Pemasukan',
        kategoriId: 1,
        nominal: 5000000,
        keterangan: 'Gaji bulan Januari',
      ),
      Transaksi(
        id: 2,
        namaTransaksi: 'Belanja Bulanan',
        tanggal: '2024-01-05',
        jenis: 'Pengeluaran',
        kategoriId: 2,
        nominal: 2000000,
        keterangan: 'Belanja kebutuhan',
      ),
      Transaksi(
        id: 3,
        namaTransaksi: 'Bonus',
        tanggal: '2024-01-10',
        jenis: 'Pemasukan',
        kategoriId: 1,
        nominal: 1000000,
        keterangan: 'Bonus kinerja',
      ),
      Transaksi(
        id: 4,
        namaTransaksi: 'Transportasi',
        tanggal: '2024-01-15',
        jenis: 'Pengeluaran',
        kategoriId: 3,
        nominal: 500000,
        keterangan: 'Biaya transportasi',
      ),
    ];
  }
}

/// Helper class for widget testing
class WidgetTestHelper {
  /// Wraps a widget with MaterialApp and ProviderScope for testing
  static Widget wrapWithMaterialApp(Widget child, {List<Override>? overrides}) {
    return ProviderScope(
      overrides: overrides ?? [],
      child: MaterialApp(home: child),
    );
  }

  /// Wraps a widget with Scaffold for testing
  static Widget wrapWithScaffold(Widget child) {
    return Scaffold(body: child);
  }

  /// Pumps a widget with ProviderScope
  static Future<void> pumpProviderScope(
    WidgetTester tester,
    Widget child, {
    List<Override>? overrides,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: overrides ?? [],
        child: MaterialApp(home: child),
      ),
    );
  }

  /// Waits for all animations and microtasks to complete
  static Future<void> pumpAndSettle(
    WidgetTester tester, {
    Duration duration = const Duration(milliseconds: 100),
  }) async {
    await tester.pumpAndSettle(duration);
  }
}

/// Helper class for expectations
class TestExpectations {
  /// Expects a widget to be found in the tree
  static void expectWidgetFound(Finder finder) {
    expect(finder, findsOneWidget);
  }

  /// Expects multiple widgets to be found
  static void expectWidgetsFound(Finder finder, int count) {
    expect(finder, findsNWidgets(count));
  }

  /// Expects a widget not to be found
  static void expectWidgetNotFound(Finder finder) {
    expect(finder, findsNothing);
  }

  /// Expects text to be present
  static void expectTextPresent(String text) {
    expect(find.text(text), findsOneWidget);
  }

  /// Expects text not to be present
  static void expectTextNotPresent(String text) {
    expect(find.text(text), findsNothing);
  }

  /// Expects icon to be present
  static void expectIconPresent(IconData icon) {
    expect(find.byIcon(icon), findsOneWidget);
  }
}

/// Helper for creating mock providers
class MockProviderHelper {
  /// Creates a mock override for a provider
  static Override createOverride<T>(ProviderBase<T> provider, T value) {
    return provider.overrideWithValue(value);
  }
}

/// Helper for date and time in tests
class TestDateHelper {
  /// Returns a standard test date
  static DateTime getTestDate() {
    return DateTime(2024, 1, 15);
  }

  /// Returns a formatted test date string
  static String getTestDateString() {
    return '2024-01-15';
  }

  /// Returns a range of dates
  static List<String> getDateRange(int days) {
    final startDate = DateTime(2024, 1, 1);
    return List.generate(days, (index) {
      final date = startDate.add(Duration(days: index));
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    });
  }
}

/// Helper for assertions in tests
class TestAssertions {
  /// Asserts that a value is within a range
  static void assertInRange(num value, num min, num max) {
    expect(value, greaterThanOrEqualTo(min));
    expect(value, lessThanOrEqualTo(max));
  }

  /// Asserts that a list is not empty
  static void assertListNotEmpty<T>(List<T> list) {
    expect(list, isNotEmpty);
  }

  /// Asserts that a list has a specific length
  static void assertListLength<T>(List<T> list, int expectedLength) {
    expect(list.length, expectedLength);
  }

  /// Asserts that a value is positive
  static void assertPositive(num value) {
    expect(value, greaterThan(0));
  }

  /// Asserts that a value is negative
  static void assertNegative(num value) {
    expect(value, lessThan(0));
  }

  /// Asserts that two values are approximately equal
  static void assertApproximatelyEqual(
    num actual,
    num expected, {
    double delta = 0.01,
  }) {
    expect(actual, closeTo(expected, delta));
  }
}
