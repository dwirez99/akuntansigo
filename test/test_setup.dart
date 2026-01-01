import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Initialize sqflite_ffi for testing
/// This must be called before any tests that use the database
void setupTestDatabase() {
  // Initialize FFI
  sqfliteFfiInit();

  // Set the database factory for tests
  databaseFactory = databaseFactoryFfi;
}

/// Setup for all tests
void setupTests() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupTestDatabase();
}
