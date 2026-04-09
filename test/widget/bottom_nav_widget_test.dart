// test/widget/bottom_nav_widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pam_p7_2026_ifs23019/core/theme/app_theme.dart';
import 'package:pam_p7_2026_ifs23019/core/theme/theme_notifier.dart';
import 'package:pam_p7_2026_ifs23019/shared/widgets/bottom_nav_widget.dart';

Widget buildNavTestApp(String initialRoute) {
  final notifier = ThemeNotifier(initial: ThemeMode.light);

  final router = GoRouter(
    initialLocation: initialRoute,
    routes: [
      ShellRoute(
        builder: (context, state, child) =>
            Scaffold(body: child, bottomNavigationBar: BottomNavWidget(child: child)),
        routes: [
          // GUNAKAN KEY KECIL SEMUA AGAR AMAN
          GoRoute(path: '/', builder: (_, _) => const SizedBox(key: Key('home_page'))),
          GoRoute(path: '/plants', builder: (_, _) => const SizedBox(key: Key('plants_page'))),
          GoRoute(path: '/desserts', builder: (_, _) => const SizedBox(key: Key('desserts_page'))),
          GoRoute(path: '/profile', builder: (_, _) => const SizedBox(key: Key('profile_page'))),
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
  group('BottomNavWidget Test (Stable Version)', () {
    Future<void> pumpNav(WidgetTester tester, String route) async {
      await tester.pumpWidget(buildNavTestApp(route));
      await tester.pump(const Duration(milliseconds: 500));
    }

    testWidgets('menekan Desserts menavigasi ke halaman Desserts', (tester) async {
      await pumpNav(tester, '/');
      await tester.tap(find.byKey(const Key('Desserts')));
      await tester.pumpAndSettle(); // Navigasi ke SizedBox aman pakai pumpAndSettle

      // Cari desserts_page (huruf kecil)
      expect(find.byKey(const Key('desserts_page')), findsOneWidget);
    });

    testWidgets('navigasi antar menu bekerja tanpa error', (tester) async {
      await pumpNav(tester, '/');

      // Pindah ke Profile
      await tester.tap(find.byKey(const Key('Profile')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('profile_page')), findsOneWidget);

      // Kembali ke Desserts
      await tester.tap(find.byKey(const Key('Desserts')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('desserts_page')), findsOneWidget);
    });
  });
}