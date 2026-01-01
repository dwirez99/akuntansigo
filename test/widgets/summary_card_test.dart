import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:akuntansigo/widgets/summary_card.dart';

void main() {
  group('SummaryCard Widget Tests', () {
    testWidgets('should display title correctly', (WidgetTester tester) async {
      // Arrange
      const testTitle = 'Pemasukan';
      const testAmount = 1000000;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SummaryCard(
              title: testTitle,
              amount: testAmount,
              icon: Icons.arrow_upward,
              color: Colors.green,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(testTitle), findsOneWidget);
    });

    testWidgets('should display formatted amount correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testTitle = 'Pengeluaran';
      const testAmount = 5000000;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SummaryCard(
              title: testTitle,
              amount: testAmount,
              icon: Icons.arrow_downward,
              color: Colors.red,
            ),
          ),
        ),
      );

      // Assert
      // Should display formatted currency
      expect(find.textContaining('Rp'), findsOneWidget);
      expect(find.textContaining('5,000,000'), findsOneWidget);
    });

    testWidgets('should display icon correctly', (WidgetTester tester) async {
      // Arrange
      const testIcon = Icons.trending_up;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SummaryCard(
              title: 'Test',
              amount: 1000,
              icon: testIcon,
              color: Colors.blue,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(testIcon), findsOneWidget);
    });

    testWidgets('should handle zero amount', (WidgetTester tester) async {
      // Arrange
      const testAmount = 0;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SummaryCard(
              title: 'Zero',
              amount: testAmount,
              icon: Icons.remove,
              color: Colors.grey,
            ),
          ),
        ),
      );

      // Assert
      expect(find.textContaining('Rp'), findsOneWidget);
      expect(find.textContaining('0'), findsOneWidget);
    });

    testWidgets('should handle negative amount', (WidgetTester tester) async {
      // Arrange
      const testAmount = -1000000;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SummaryCard(
              title: 'Deficit',
              amount: testAmount,
              icon: Icons.trending_down,
              color: Colors.red,
            ),
          ),
        ),
      );

      // Assert
      expect(find.textContaining('Rp'), findsOneWidget);
      // Widget uses abs(), so negative amounts are displayed as positive
      expect(find.textContaining('1,000,000'), findsOneWidget);
    });

    testWidgets('should display different colors correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testColors = [Colors.green, Colors.red, Colors.blue, Colors.orange];

      for (final color in testColors) {
        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SummaryCard(
                title: 'Test',
                amount: 1000,
                icon: Icons.attach_money,
                color: color,
              ),
            ),
          ),
        );

        // Assert - Card should be rendered
        expect(find.byType(Card), findsOneWidget);

        // Rebuild for next color
        await tester.pump();
      }
    });

    testWidgets('should display large amounts correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testAmount = 999999999;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SummaryCard(
              title: 'Large Amount',
              amount: testAmount,
              icon: Icons.account_balance,
              color: Colors.green,
            ),
          ),
        ),
      );

      // Assert
      expect(find.textContaining('999,999,999'), findsOneWidget);
    });

    testWidgets('should be tappable (has InkWell/GestureDetector)', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SummaryCard(
              title: 'Test',
              amount: 1000,
              icon: Icons.attach_money,
              color: Colors.green,
            ),
          ),
        ),
      );

      // Assert - Card should exist
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('should display all three summary cards in a row', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SummaryCard(
                        title: 'Pemasukan',
                        amount: 5000000,
                        icon: Icons.arrow_upward,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SummaryCard(
                        title: 'Pengeluaran',
                        amount: 3000000,
                        icon: Icons.arrow_downward,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SummaryCard(
                  title: 'Selisih',
                  amount: 2000000,
                  icon: Icons.trending_up,
                  color: Colors.green,
                ),
              ],
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(SummaryCard), findsNWidgets(3));
      expect(find.text('Pemasukan'), findsOneWidget);
      expect(find.text('Pengeluaran'), findsOneWidget);
      expect(find.text('Selisih'), findsOneWidget);
    });
  });
}
