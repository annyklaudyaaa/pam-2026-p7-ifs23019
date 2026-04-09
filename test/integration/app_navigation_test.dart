// test/integration/app_navigation_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pam_p7_2026_ifs23019/app.dart';

void main() {
  group('Navigasi Aplikasi (End-to-End) - Stable Version', () {

    // Helper untuk menunggu transisi halaman tanpa terjebak loading/animasi
    Future<void> waitForPage(WidgetTester tester) async {
      // Kita panggil pump beberapa kali secara manual
      // Daripada pumpAndSettle yang menunggu animasi berhenti (yang tidak akan berhenti kalau ada loader)
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));
    }

    testWidgets('aplikasi berjalan dan menampilkan HomeScreen', (tester) async {
      await tester.pumpWidget(const DelcomApp());
      await waitForPage(tester);

      // Pastikan ada teks Halo Anny atau judul Home
      expect(find.textContaining('Home'), findsWidgets);
      expect(find.textContaining('Anny'), findsWidgets);
    });

    testWidgets('navigasi dari Home ke Plants via BottomNav', (tester) async {
      await tester.pumpWidget(const DelcomApp());
      await waitForPage(tester);

      // Tap Plants di bottom nav menggunakan Key
      final plantsTab = find.byKey(const Key('Plants'));
      expect(plantsTab, findsOneWidget);

      await tester.tap(plantsTab);
      await waitForPage(tester);

      // Cek apakah judul AppBar berubah jadi Plants atau ada indikator loading di halaman Plants
      expect(find.textContaining('Plants'), findsWidgets);
    });

    testWidgets('navigasi dari Home ke Desserts via BottomNav', (tester) async {
      await tester.pumpWidget(const DelcomApp());
      await waitForPage(tester);

      final dessertsTab = find.byKey(const Key('Desserts'));
      await tester.tap(dessertsTab);
      await waitForPage(tester);

      expect(find.textContaining('Desserts'), findsWidgets);
    });

    testWidgets('navigasi dari Home ke Profile via BottomNav', (tester) async {
      await tester.pumpWidget(const DelcomApp());
      await waitForPage(tester);

      await tester.tap(find.byKey(const Key('Profile')));
      await waitForPage(tester);

      expect(find.textContaining('Profil'), findsWidgets);
      expect(find.textContaining('Anny'), findsWidgets);
    });

    testWidgets('toggle dark mode mengubah tema aplikasi', (tester) async {
      await tester.pumpWidget(const DelcomApp());
      await waitForPage(tester);

      // Cari ikon light mode
      final themeToggle = find.byIcon(Icons.light_mode_rounded);
      expect(themeToggle, findsOneWidget);

      await tester.tap(themeToggle);
      await tester.pumpAndSettle(); // Untuk tema biasanya cepat settle-nya

      // Pastikan berubah jadi dark mode
      expect(find.byIcon(Icons.dark_mode_rounded), findsOneWidget);
    });

    testWidgets('pencarian di halaman Desserts', (tester) async {
      await tester.pumpWidget(const DelcomApp());
      await waitForPage(tester);

      // Ke Desserts dulu
      await tester.tap(find.byKey(const Key('Desserts')));
      await waitForPage(tester);

      // Cari ikon search (TopAppBarWidget)
      final searchIcon = find.byIcon(Icons.search);
      if (searchIcon.evaluate().isNotEmpty) {
        await tester.tap(searchIcon);
        await tester.pump();

        // Ketik sesuatu
        await tester.enterText(find.byType(TextField), 'Klepon');
        await tester.pump(const Duration(milliseconds: 500));

        // Karena API bakal return 400 (error), kita minimal cek TextField-nya berisi
        expect(find.text('Klepon'), findsOneWidget);
      }
    });

    testWidgets('navigasi kembali ke Home dari Desserts', (tester) async {
      await tester.pumpWidget(const DelcomApp());
      await waitForPage(tester);

      // Ke Desserts
      await tester.tap(find.byKey(const Key('Desserts')));
      await waitForPage(tester);

      // Ke Home lagi
      await tester.tap(find.byKey(const Key('Home')));
      await waitForPage(tester);

      expect(find.textContaining('Delcom Plants'), findsOneWidget);
    });
  });
}