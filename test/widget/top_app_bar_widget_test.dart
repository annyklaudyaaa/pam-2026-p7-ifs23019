// test/widget/top_app_bar_widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pam_p7_2026_ifs23019/core/theme/app_theme.dart';
import 'package:pam_p7_2026_ifs23019/core/theme/theme_notifier.dart';
import 'package:pam_p7_2026_ifs23019/shared/widgets/top_app_bar_widget.dart';

/// Helper untuk membungkus widget dengan semua provider yang dibutuhkan
Widget buildTestApp({required Widget child}) {
  final notifier = ThemeNotifier(initial: ThemeMode.light);
  final router = GoRouter(routes: [
    GoRoute(path: '/', builder: (_, _) => child),
  ]);

  return ThemeProvider(
    notifier: notifier,
    child: MaterialApp.router(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: router,
    ),
  );
}

void main() {
  group('TopAppBarWidget (Dessert & Smart Features)', () {
    testWidgets('menampilkan judul dengan benar', (tester) async {
      await tester.pumpWidget(buildTestApp(
        child: const Scaffold(
          appBar: TopAppBarWidget(title: 'Delcom Desserts'),
          body: SizedBox(),
        ),
      ));

      expect(find.text('Delcom Desserts'), findsOneWidget);
    });

    testWidgets('menampilkan tombol back iOS style saat showBackButton = true',
            (tester) async {
          await tester.pumpWidget(buildTestApp(
            child: const Scaffold(
              appBar: TopAppBarWidget(title: 'Detail Cake', showBackButton: true),
              body: SizedBox(),
            ),
          ));

          // Menggunakan ikon baru: Icons.arrow_back_ios_new
          expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);
        });

    testWidgets('menampilkan ikon light_mode_rounded saat awal (Light Mode)',
            (tester) async {
          await tester.pumpWidget(buildTestApp(
            child: const Scaffold(
              appBar: TopAppBarWidget(title: 'Home'),
              body: SizedBox(),
            ),
          ));

          // Sesuai update: Icons.light_mode_rounded
          expect(find.byIcon(Icons.light_mode_rounded), findsOneWidget);
        });

    testWidgets('ikon berubah ke dark_mode_rounded saat tema diganti',
            (tester) async {
          await tester.pumpWidget(buildTestApp(
            child: const Scaffold(
              appBar: TopAppBarWidget(title: 'Home'),
              body: SizedBox(),
            ),
          ));

          await tester.tap(find.byIcon(Icons.light_mode_rounded));
          await tester.pumpAndSettle();

          expect(find.byIcon(Icons.dark_mode_rounded), findsOneWidget);
        });

    testWidgets('menampilkan Hint Text dessert yang manis saat mencari di halaman Dessert',
            (tester) async {
          await tester.pumpWidget(buildTestApp(
            child: const Scaffold(
              appBar: TopAppBarWidget(title: 'My Desserts', withSearch: true),
              body: SizedBox(),
            ),
          ));

          // Aktifkan pencarian
          await tester.tap(find.byIcon(Icons.search));
          await tester.pumpAndSettle();

          // Cek apakah Hint Text berubah sesuai logika cerdas kita
          expect(find.text('Cari dessert manis... 🍰'), findsOneWidget);
        });

    testWidgets('judul berwarna primary (Pink) saat di halaman Dessert',
            (tester) async {
          await tester.pumpWidget(buildTestApp(
            child: const Scaffold(
              appBar: TopAppBarWidget(title: 'Dessert Menu'),
              body: SizedBox(),
            ),
          ));

          final Text titleText = tester.widget(find.text('Dessert Menu'));

          // Mengambil colorScheme dari context aplikasi test
          final BuildContext context = tester.element(find.byType(Scaffold));
          final primaryColor = Theme.of(context).colorScheme.primary;

          // Pastikan warnanya Pink Strawberry (Primary)
          expect(titleText.style?.color, equals(primaryColor));
        });

    testWidgets('menekan tombol close mereset query pencarian', (tester) async {
      String currentQuery = 'brownies';

      await tester.pumpWidget(buildTestApp(
        child: Scaffold(
          appBar: TopAppBarWidget(
            title: 'Desserts',
            withSearch: true,
            onSearchQueryChange: (q) => currentQuery = q,
          ),
          body: const SizedBox(),
        ),
      ));

      // Buka search dan ketik
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'brownies');

      // Tutup search
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Query harus kembali kosong ('')
      expect(currentQuery, equals(''));
      expect(find.byType(TextField), findsNothing);
    });
  });
}