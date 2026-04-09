// test/widget/screens/home_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart'; // Tambahkan ini
import 'package:pam_p7_2026_ifs23019/core/theme/app_theme.dart';
import 'package:pam_p7_2026_ifs23019/core/theme/theme_notifier.dart';
import 'package:pam_p7_2026_ifs23019/features/home/home_screen.dart';

Widget buildHomeTest() {
  final notifier = ThemeNotifier(initial: ThemeMode.light);

  // Jika HomeScreen kamu butuh data dari DessertProvider atau PlantProvider,
  // mereka harus dibungkus di sini. Untuk sekarang kita buat minimalis.
  final router = GoRouter(routes: [
    GoRoute(path: '/', builder: (_, _) => const HomeScreen()),
  ]);

  return ThemeProvider(
    notifier: notifier,
    child: MaterialApp.router(
      theme: AppTheme.lightTheme,
      routerConfig: router,
    ),
  );
}

void main() {
  group('HomeScreen Widget Test (Fix Timeout Version)', () {

    // Helper untuk memompa widget dengan durasi stabil
    Future<void> pumpHome(WidgetTester tester) async {
      await tester.pumpWidget(buildHomeTest());
      // Ganti pumpAndSettle dengan pump durasi manual untuk menghindari timeout
      await tester.pump(const Duration(milliseconds: 500));
    }

    testWidgets('merender tanpa error', (tester) async {
      await pumpHome(tester);
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('menampilkan judul "Home" di AppBar', (tester) async {
      await pumpHome(tester);
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('menampilkan section Delcom Plants', (tester) async {
      await pumpHome(tester);
      // Menggunakan find.textContaining agar lebih fleksibel
      expect(find.textContaining('Delcom Plants'), findsOneWidget);
      expect(find.text('🌱'), findsOneWidget);
    });

    testWidgets('menampilkan section Delcom Desserts', (tester) async {
      await pumpHome(tester);
      expect(find.textContaining('Delcom Desserts'), findsOneWidget);
      expect(find.text('🍰'), findsOneWidget);
    });

    testWidgets('menampilkan pesan sapaan personal untuk Anny', (tester) async {
      await pumpHome(tester);
      // Pastikan teks sapaan ini sesuai dengan yang ada di kodingan HomeScreen kamu
      expect(find.textContaining('Halo Anny!'), findsOneWidget);
    });

    testWidgets('menampilkan tombol toggle light mode menggunakan ikon rounded', (tester) async {
      await pumpHome(tester);
      // Kadang di test, icon rounded terbaca sebagai IconData yang sama
      expect(find.byIcon(Icons.light_mode_rounded), findsOneWidget);
    });
  });
}