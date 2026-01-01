import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:akuntansigo/screens/transaksi_form_screen.dart';

void main() {
  group('CurrencyInputFormatter Tests', () {
    late CurrencyInputFormatter formatter;

    setUp(() {
      formatter = CurrencyInputFormatter();
    });

    test('should format single digit correctly', () {
      // Arrange
      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(text: '5');

      // Act
      final result = formatter.formatEditUpdate(oldValue, newValue);

      // Assert
      expect(result.text, '5');
      expect(result.selection.baseOffset, 1);
    });

    test('should format three digits correctly', () {
      // Arrange
      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(text: '100');

      // Act
      final result = formatter.formatEditUpdate(oldValue, newValue);

      // Assert
      expect(result.text, '100');
    });

    test('should format four digits with thousand separator', () {
      // Arrange
      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(text: '1000');

      // Act
      final result = formatter.formatEditUpdate(oldValue, newValue);

      // Assert
      expect(result.text, '1.000');
      expect(result.selection.baseOffset, 5);
    });

    test('should format five digits with thousand separator', () {
      // Arrange
      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(text: '10000');

      // Act
      final result = formatter.formatEditUpdate(oldValue, newValue);

      // Assert
      expect(result.text, '10.000');
    });

    test('should format six digits with thousand separator', () {
      // Arrange
      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(text: '100000');

      // Act
      final result = formatter.formatEditUpdate(oldValue, newValue);

      // Assert
      expect(result.text, '100.000');
    });

    test('should format seven digits with thousand separators', () {
      // Arrange
      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(text: '1000000');

      // Act
      final result = formatter.formatEditUpdate(oldValue, newValue);

      // Assert
      expect(result.text, '1.000.000');
    });

    test('should format millions correctly', () {
      // Arrange
      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(text: '5000000');

      // Act
      final result = formatter.formatEditUpdate(oldValue, newValue);

      // Assert
      expect(result.text, '5.000.000');
    });

    test('should handle empty input', () {
      // Arrange
      const oldValue = TextEditingValue(text: '1000');
      const newValue = TextEditingValue.empty;

      // Act
      final result = formatter.formatEditUpdate(oldValue, newValue);

      // Assert
      expect(result.text, '');
    });

    test('should strip existing dots before formatting', () {
      // Arrange
      const oldValue = TextEditingValue(text: '1.000');
      const newValue = TextEditingValue(text: '1.0005');

      // Act
      final result = formatter.formatEditUpdate(oldValue, newValue);

      // Assert
      expect(result.text, '10.005');
    });

    test('should handle only non-digit characters', () {
      // Arrange
      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(text: 'abc');

      // Act
      final result = formatter.formatEditUpdate(oldValue, newValue);

      // Assert
      expect(result.text, '');
    });

    test('should remove non-digit characters and format', () {
      // Arrange
      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(text: 'a1b2c3d4');

      // Act
      final result = formatter.formatEditUpdate(oldValue, newValue);

      // Assert
      expect(result.text, '1.234');
    });

    test('should handle very large numbers', () {
      // Arrange
      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(text: '999999999');

      // Act
      final result = formatter.formatEditUpdate(oldValue, newValue);

      // Assert
      expect(result.text, '999.999.999');
    });

    test('should place cursor at end after formatting', () {
      // Arrange
      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(text: '50000');

      // Act
      final result = formatter.formatEditUpdate(oldValue, newValue);

      // Assert
      expect(result.text, '50.000');
      expect(result.selection.baseOffset, 6);
      expect(result.selection.extentOffset, 6);
    });

    test('should format incrementally when typing', () {
      // Arrange & Act
      const value1 = TextEditingValue(text: '1');
      final result1 = formatter.formatEditUpdate(
        TextEditingValue.empty,
        value1,
      );

      const value2 = TextEditingValue(text: '10');
      final result2 = formatter.formatEditUpdate(result1, value2);

      const value3 = TextEditingValue(text: '100');
      final result3 = formatter.formatEditUpdate(result2, value3);

      const value4 = TextEditingValue(text: '1000');
      final result4 = formatter.formatEditUpdate(result3, value4);

      // Assert
      expect(result1.text, '1');
      expect(result2.text, '10');
      expect(result3.text, '100');
      expect(result4.text, '1.000');
    });

    test('should handle zero correctly', () {
      // Arrange
      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(text: '0');

      // Act
      final result = formatter.formatEditUpdate(oldValue, newValue);

      // Assert
      expect(result.text, '0');
    });

    test('should format multiple zeros', () {
      // Arrange
      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(text: '10000');

      // Act
      final result = formatter.formatEditUpdate(oldValue, newValue);

      // Assert
      expect(result.text, '10.000');
    });

    test('should handle mixed characters in input', () {
      // Arrange
      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(text: '1.2.3.4.5');

      // Act
      final result = formatter.formatEditUpdate(oldValue, newValue);

      // Assert
      expect(result.text, '12.345');
    });

    test('should format when pasting formatted text', () {
      // Arrange
      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(text: '5.000.000');

      // Act
      final result = formatter.formatEditUpdate(oldValue, newValue);

      // Assert
      expect(result.text, '5.000.000');
    });

    test('should handle leading zeros', () {
      // Arrange
      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(text: '0001000');

      // Act
      final result = formatter.formatEditUpdate(oldValue, newValue);

      // Assert
      expect(result.text, '1.000');
    });
  });
}
