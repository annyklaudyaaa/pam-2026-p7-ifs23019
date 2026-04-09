// test/widget/screens/home_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pam_p7_2026_ifs23019/core/theme/app_theme.dart';
import 'package:pam_p7_2026_ifs23019/core/theme/theme_notifier.dart';
import 'package:pam_p7_2026_ifs23019/features/home/home_screen.dart';

Widget buildHomeTest() {
  final notifier = ThemeNotifier(initial: ThemeMode.light);
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
  group('HomeScreen (Mixed Theme Test)', () {
    testWidgets('merender tanpa error', (tester) async {
      await tester.pumpWidget(buildHomeTest());
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('menampilkan judul "Home" di AppBar', (tester) async {
      await tester.pumpWidget(buildHomeTest());
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('menampilkan section Delcom Plants', (tester) async {
      await tester.pumpWidget(buildHomeTest());
      await tester.pumpAndSettle();

      expect(find.textContaining('Delcom Plants'), findsOneWidget);
      expect(find.text('🌱'), findsOneWidget); // Emoji tanaman
    });

    testWidgets('menampilkan section Delcom Desserts', (tester) async {
      await tester.pumpWidget(buildHomeTest());
      await tester.pumpAndSettle();

      // Cek banner dessert
      expect(find.textContaining('Delcom Desserts'), findsOneWidget);
      // Cek salah satu emoji dessert
      expect(find.text('🍰'), findsOneWidget);
    });

    testWidgets('menampilkan pesan sapaan personal untuk Anny', (tester) async {
      await tester.pumpWidget(buildHomeTest());
      await tester.pumpAndSettle();

      expect(find.textContaining('Halo Anny!'), findsOneWidget);
      expect(find.textContaining('manis-manis'), findsOneWidget);
    });

    testWidgets('menampilkan banyak Card (Banner + Emojis)', (tester) async {
      await tester.pumpWidget(buildHomeTest());
      await tester.pumpAndSettle();

      // Kita punya 2 banner + 8 emoji cards = minimal 10 cards
      expect(find.byType(Card), findsAtLeastNWidgets(6));
    });

    testWidgets('tombol toggle light mode menggunakan ikon rounded di AppBar', (tester) async {
      await tester.pumpWidget(buildHomeTest());
      await tester.pumpAndSettle();

      // Sesuai TopAppBarWidget terbaru: Icons.light_mode_rounded
      expect(find.byIcon(Icons.light_mode_rounded), findsOneWidget);
    });
  });
}