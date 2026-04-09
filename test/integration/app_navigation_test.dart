// test/integration/app_navigation_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pam_p7_2026_ifs23019/app.dart';

void main() {
  group('Navigasi Aplikasi (End-to-End)', () {
    testWidgets('aplikasi berjalan dan menampilkan HomeScreen', (tester) async {
      // Menggunakan DelcomApp (nama baru)
      await tester.pumpWidget(const DelcomApp());
      await tester.pumpAndSettle();

      // Halaman awal adalah Home
      expect(find.widgetWithText(AppBar, 'Home'), findsOneWidget);
      expect(find.textContaining('Delcom Desserts'), findsOneWidget);
    });

    testWidgets('navigasi dari Home ke Plants via BottomNav', (tester) async {
      await tester.pumpWidget(const DelcomApp());
      await tester.pumpAndSettle();

      // Tap Plants di bottom nav
      await tester.tap(find.byKey(const Key('Plants')));
      await tester.pumpAndSettle();

      // Halaman Plants muncul
      expect(find.text('Plants'), findsWidgets);
    });

    testWidgets('navigasi dari Home ke Desserts via BottomNav', (tester) async {
      await tester.pumpWidget(const DelcomApp());
      await tester.pumpAndSettle();

      // Tap Desserts di bottom nav
      await tester.tap(find.byKey(const Key('Desserts')));
      await tester.pumpAndSettle();

      // Halaman Desserts muncul (dengan emoji sesuai judul di Screen)
      expect(find.textContaining('Desserts'), findsWidgets);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('navigasi dari Home ke Profile via BottomNav', (tester) async {
      await tester.pumpWidget(const DelcomApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('Profile')));
      await tester.pumpAndSettle();

      expect(find.text('Tentang Saya'), findsOneWidget);
    });

    testWidgets('toggle dark mode mengubah tema aplikasi', (tester) async {
      await tester.pumpWidget(const DelcomApp());
      await tester.pumpAndSettle();

      // Ikon di TopAppBarWidget terbaru menggunakan _rounded
      expect(find.byIcon(Icons.light_mode_rounded), findsOneWidget);

      // Toggle ke dark mode
      await tester.tap(find.byIcon(Icons.light_mode_rounded));
      await tester.pumpAndSettle();

      // Ikon berubah ke dark mode rounded
      expect(find.byIcon(Icons.dark_mode_rounded), findsOneWidget);
    });

    testWidgets('pencarian di halaman Desserts dapat menemukan makanan',
            (tester) async {
          await tester.pumpWidget(const DelcomApp());
          await tester.pumpAndSettle();

          // Navigasi ke Desserts
          await tester.tap(find.byKey(const Key('Desserts')));
          await tester.pumpAndSettle();

          // Buka search
          await tester.tap(find.byIcon(Icons.search));
          await tester.pumpAndSettle();

          // Ketik nama dessert (Contoh: Klepon)
          await tester.enterText(find.byType(TextField), 'Klepon');
          await tester.pumpAndSettle();

          // Pastikan pencarian memberikan hasil
          expect(find.text('Klepon'), findsWidgets);
        });

    testWidgets('toggle dark mode tetap aktif saat berpindah ke Desserts',
            (tester) async {
          await tester.pumpWidget(const DelcomApp());
          await tester.pumpAndSettle();

          // Aktifkan dark mode di Home
          await tester.tap(find.byIcon(Icons.light_mode_rounded));
          await tester.pumpAndSettle();

          // Pindah ke Desserts
          await tester.tap(find.byKey(const Key('Desserts')));
          await tester.pumpAndSettle();

          // Ikon tetap dark_mode_rounded
          expect(find.byIcon(Icons.dark_mode_rounded), findsOneWidget);
        });

    testWidgets('navigasi kembali ke Home dari Desserts menggunakan BottomNav',
            (tester) async {
          await tester.pumpWidget(const DelcomApp());
          await tester.pumpAndSettle();

          // Navigasi ke Desserts
          await tester.tap(find.byKey(const Key('Desserts')));
          await tester.pumpAndSettle();

          // Kembali ke Home
          await tester.tap(find.byKey(const Key('Home')));
          await tester.pumpAndSettle();

          // Banner Home ditampilkan
          expect(find.textContaining('Delcom Desserts'), findsOneWidget);
          expect(find.textContaining('Delcom Plants'), findsOneWidget);
        });
  });
}