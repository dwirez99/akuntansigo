# Test Documentation - Akuntansi Go

## Overview

This directory contains comprehensive unit and widget tests for the Akuntansi Go application. The tests are organized by component type and follow Flutter testing best practices.

## Test Structure

```
test/
├── helpers/
│   └── test_helpers.dart          # Shared test utilities and helpers
├── models/
│   ├── analisis_data_test.dart    # Tests for AnalisisData model
│   ├── kategori_test.dart         # Tests for Kategori model
│   └── transaksi_test.dart        # Tests for Transaksi model
├── providers/
│   └── (provider tests)           # Tests for Riverpod providers
├── services/
│   └── currency_formatter_test.dart # Tests for CurrencyInputFormatter
├── widgets/
│   └── summary_card_test.dart     # Tests for SummaryCard widget
└── README.md                      # This file
```

## Running Tests

### Run All Tests
```bash
flutter test
```

### Run Specific Test File
```bash
flutter test test/models/transaksi_test.dart
```

### Run Tests with Coverage
```bash
flutter test --coverage
```

### View Coverage Report
```bash
# Generate coverage report
genhtml coverage/lcov.info -o coverage/html

# Open in browser (Linux)
xdg-open coverage/html/index.html
```

## Test Categories

### 1. Model Tests

**Location:** `test/models/`

Tests for data models to ensure proper:
- Object creation
- Serialization (toMap)
- Deserialization (fromMap)
- Field validation
- Data integrity

**Example:**
```dart
test('should create Transaksi from Map correctly', () {
  final map = {
    'id': 1,
    'namaTransaksi': 'Gaji Bulanan',
    'tanggal': '2024-01-15',
    'jenis': 'Pemasukan',
    'kategoriId': 1,
    'nominal': 5000000,
    'keterangan': 'Gaji bulan Januari',
  };

  final transaksi = Transaksi.fromMap(map);

  expect(transaksi.id, 1);
  expect(transaksi.namaTransaksi, 'Gaji Bulanan');
});
```

### 2. Widget Tests

**Location:** `test/widgets/`

Tests for Flutter widgets to ensure:
- Correct rendering
- User interaction
- State management
- Visual elements display

**Example:**
```dart
testWidgets('should display title correctly', (WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SummaryCard(
          title: 'Pemasukan',
          amount: 1000000,
          icon: Icons.arrow_upward,
          color: Colors.green,
        ),
      ),
    ),
  );

  expect(find.text('Pemasukan'), findsOneWidget);
});
```

### 3. Service Tests

**Location:** `test/services/`

Tests for service layer including:
- Formatters
- Utilities
- Business logic
- Data processing

**Example:**
```dart
test('should format four digits with thousand separator', () {
  final formatter = CurrencyInputFormatter();
  const newValue = TextEditingValue(text: '1000');
  
  final result = formatter.formatEditUpdate(
    TextEditingValue.empty,
    newValue,
  );

  expect(result.text, '1.000');
});
```

### 4. Provider Tests

**Location:** `test/providers/`

Tests for Riverpod providers to ensure:
- State management
- Data flow
- Provider interactions
- Async operations

## Test Helpers

The `test/helpers/test_helpers.dart` file provides reusable utilities:

### TestData
Creates mock data for testing:
```dart
final testKategori = TestData.createKategori();
final testTransaksi = TestData.createTransaksi();
final kategoriList = TestData.createKategoriList(count: 5);
```

### WidgetTestHelper
Helper methods for widget testing:
```dart
await WidgetTestHelper.pumpProviderScope(
  tester,
  MyWidget(),
  overrides: [myProvider.overrideWithValue(mockValue)],
);
```

### TestExpectations
Simplified assertions:
```dart
TestExpectations.expectTextPresent('Hello World');
TestExpectations.expectWidgetFound(find.byType(MyWidget));
```

### TestAssertions
Common assertions:
```dart
TestAssertions.assertPositive(value);
TestAssertions.assertInRange(value, 0, 100);
TestAssertions.assertListNotEmpty(myList);
```

## Writing New Tests

### 1. Model Tests Template

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:akuntansigo/models/your_model.dart';

void main() {
  group('YourModel Tests', () {
    test('should create instance with all fields', () {
      // Arrange
      // Act
      // Assert
    });

    test('should convert to Map correctly', () {
      // Test implementation
    });

    test('should create from Map correctly', () {
      // Test implementation
    });
  });
}
```

### 2. Widget Tests Template

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:akuntansigo/widgets/your_widget.dart';

void main() {
  group('YourWidget Tests', () {
    testWidgets('should render correctly', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: YourWidget(),
          ),
        ),
      );

      // Act & Assert
      expect(find.byType(YourWidget), findsOneWidget);
    });
  });
}
```

## Best Practices

### 1. Test Organization
- Group related tests using `group()`
- Use descriptive test names
- Follow AAA pattern (Arrange, Act, Assert)

### 2. Test Isolation
- Each test should be independent
- Use `setUp()` and `tearDown()` for common setup
- Don't rely on test execution order

### 3. Assertions
- Use specific matchers (e.g., `equals`, `greaterThan`)
- Test both positive and negative cases
- Verify edge cases

### 4. Widget Testing
- Pump widgets completely with `pumpAndSettle()`
- Test user interactions
- Verify widget state changes
- Test accessibility

### 5. Coverage Goals
- Aim for 80%+ code coverage
- Focus on business logic
- Test edge cases and error handling

## Common Test Patterns

### Testing Async Operations
```dart
test('should handle async operations', () async {
  final result = await asyncFunction();
  expect(result, expectedValue);
});
```

### Testing Exceptions
```dart
test('should throw exception for invalid input', () {
  expect(
    () => functionThatThrows(),
    throwsA(isA<CustomException>()),
  );
});
```

### Testing with Mocks (using Mockito)
```dart
class MockDatabase extends Mock implements Database {}

test('should call database correctly', () async {
  final mockDb = MockDatabase();
  when(mockDb.getData()).thenAnswer((_) async => mockData);
  
  final result = await service.fetchData(mockDb);
  
  verify(mockDb.getData()).called(1);
  expect(result, mockData);
});
```

## Dependencies

The following packages are used for testing:

- `flutter_test`: Flutter's testing framework
- `mockito`: For creating mock objects
- `build_runner`: For generating mock code

## Continuous Integration

Tests should be run as part of CI/CD pipeline:

```yaml
# Example GitHub Actions workflow
- name: Run tests
  run: flutter test --coverage
  
- name: Upload coverage
  run: bash <(curl -s https://codecov.io/bash)
```

## Troubleshooting

### Tests Failing Locally
1. Run `flutter clean`
2. Run `flutter pub get`
3. Run tests again

### Widget Tests Not Pumping
- Ensure you call `await tester.pumpWidget()`
- Use `await tester.pumpAndSettle()` for animations

### Coverage Not Generating
- Ensure `--coverage` flag is used
- Check that `lcov` is installed on your system

## Contributing

When adding new features:
1. Write tests first (TDD approach recommended)
2. Ensure all tests pass
3. Maintain or improve coverage percentage
4. Update this README if adding new test categories

## Resources

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Effective Dart: Testing](https://dart.dev/guides/language/effective-dart/testing)
- [Widget Testing](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Mockito Documentation](https://pub.dev/packages/mockito)

## Test Coverage Status

Current coverage goals:
- [ ] Models: 100%
- [ ] Widgets: 80%+
- [ ] Services: 90%+
- [ ] Providers: 80%+
- [ ] Overall: 80%+

---

**Last Updated:** December 2024
**Maintained By:** Development Team