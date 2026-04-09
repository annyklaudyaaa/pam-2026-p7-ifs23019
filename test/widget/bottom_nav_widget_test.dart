// test/widget/bottom_nav_widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pam_p7_2026_ifs23019/core/theme/app_theme.dart';
import 'package:pam_p7_2026_ifs23019/core/theme/theme_notifier.dart';
import 'package:pam_p7_2026_ifs23019/shared/widgets/bottom_nav_widget.dart';

Widget buildNavTestApp(String initialRoute) {
  final notifier = ThemeNotifier(initial: ThemeMode.light);

  // Update Router untuk menyertakan route desserts
  final router = GoRouter(
    initialLocation: initialRoute,
    routes: [
      ShellRoute(
        builder: (context, state, child) =>
            Scaffold(body: child, bottomNavigationBar: BottomNavWidget(child: child)),
        routes: [
          GoRoute(path: '/', builder: (_, _) => const SizedBox(key: Key('home'))),
          GoRoute(path: '/plants', builder: (_, _) => const SizedBox(key: Key('plants'))),
          GoRoute(path: '/desserts', builder: (_, _) => const SizedBox(key: Key('desserts'))),
          GoRoute(path: '/profile', builder: (_, _) => const SizedBox(key: Key('profile'))),
        ],
      ),
    ],
  );

  return ThemeProvider(
    notifier: notifier,
    child: MaterialApp.router(
      theme: AppTheme.lightTheme,
      routerConfig: router,
    ),
  );
}

void main() {
  group('BottomNavWidget (Full Navigation Test)', () {
    testWidgets('merender empat item navigasi (Plants & Desserts)', (tester) async {
      await tester.pumpWidget(buildNavTestApp('/'));
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Plants'), findsOneWidget);
      expect(find.text('Desserts'), findsOneWidget); // Menu Baru
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('menampilkan ikon dessert aktif di halaman desserts', (tester) async {
      await tester.pumpWidget(buildNavTestApp('/desserts'));
      await tester.pumpAndSettle();

      // Ikon aktif untuk dessert adalah Icons.cake
      expect(find.byIcon(Icons.cake), findsOneWidget);
    });

    testWidgets('menekan Desserts menavigasi ke halaman Desserts', (tester) async {
      await tester.pumpWidget(buildNavTestApp('/'));
      await tester.pumpAndSettle();

      // Cari item Desserts menggunakan key yang sudah kita pasang di BottomNavWidget
      await tester.tap(find.byKey(const Key('Desserts')));
      await tester.pumpAndSettle();

      // Pastikan halaman dengan key desserts dirender
      expect(find.byKey(const Key('desserts')), findsOneWidget);
    });

    testWidgets('menampilkan indikator visual (AnimatedContainer) pada item aktif', (tester) async {
      await tester.pumpWidget(buildNavTestApp('/plants'));
      await tester.pumpAndSettle();

      // Mengecek apakah ada AnimatedContainer (untuk background highlight item aktif)
      expect(find.byType(AnimatedContainer), findsAtLeastNWidgets(1));
    });

    testWidgets('navigasi antar menu bekerja tanpa error', (tester) async {
      await tester.pumpWidget(buildNavTestApp('/'));
      await tester.pumpAndSettle();

      // Pindah ke Profile
      await tester.tap(find.byKey(const Key('Profile')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('profile')), findsOneWidget);

      // Kembali ke Desserts
      await tester.tap(find.byKey(const Key('Desserts')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('desserts')), findsOneWidget);
    });
  });
}