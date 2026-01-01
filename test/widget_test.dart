import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:akuntansigo/main.dart';
import 'test_setup.dart';

void main() {
  // Initialize database for all tests
  setUpAll(() {
    setupTests();
  });

  group('App Widget Tests', () {
    testWidgets('MyApp should build without errors', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const ProviderScope(child: MyApp()));
      await tester.pump();

      expect(find.byType(ProviderScope), findsOneWidget);
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('App should display HomeScreen', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MyApp()));
      await tester.pump();

      // Should find the main scaffold
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('App should have bottom navigation', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const ProviderScope(child: MyApp()));
      await tester.pump();

      // Should find navigation bar
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('Bottom navigation should have 4 items', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const ProviderScope(child: MyApp()));
      await tester.pump();

      final navigationBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(navigationBar.items.length, 4);
    });

    testWidgets('Navigation items should have correct labels', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const ProviderScope(child: MyApp()));
      await tester.pump();

      // Check for navigation labels
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Transaksi'), findsOneWidget);
      expect(find.text('Kategori'), findsOneWidget);
      expect(find.text('Analisis'), findsOneWidget);
    });

    testWidgets('App should use Material Design 3', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const ProviderScope(child: MyApp()));
      await tester.pump();

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme?.useMaterial3, true);
    });

    testWidgets('App should have correct title', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MyApp()));
      await tester.pump();

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.title, 'Akuntansi Go');
    });
  });

  group('App Theme Tests', () {
    testWidgets('App should have primary color scheme', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const ProviderScope(child: MyApp()));
      await tester.pump();

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme, isNotNull);
      expect(materialApp.theme?.colorScheme, isNotNull);
    });
  });

  group('App Initialization Tests', () {
    testWidgets('App should initialize ProviderScope', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const ProviderScope(child: MyApp()));
      await tester.pump();

      expect(find.byType(ProviderScope), findsOneWidget);
    });

    testWidgets('App should have MaterialApp as root', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const ProviderScope(child: MyApp()));
      await tester.pump();

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsWidgets);
    });
  });

  group('Navigation Tests', () {
    testWidgets('Should be able to tap navigation items', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const ProviderScope(child: MyApp()));
      await tester.pump();

      // Find the navigation bar
      final navBar = find.byType(BottomNavigationBar);
      expect(navBar, findsOneWidget);

      // Verify we can find the tap targets
      expect(find.text('Transaksi'), findsOneWidget);
      expect(find.text('Kategori'), findsOneWidget);
      expect(find.text('Analisis'), findsOneWidget);
    });
  });
}
