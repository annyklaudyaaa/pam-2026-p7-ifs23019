// test/widget/desserts_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pam_p7_2026_ifs23019/core/theme/app_theme.dart';
import 'package:pam_p7_2026_ifs23019/core/theme/theme_notifier.dart';
import 'package:pam_p7_2026_ifs23019/data/models/api_response_model.dart';
import 'package:pam_p7_2026_ifs23019/data/models/dessert_model.dart';
import 'package:pam_p7_2026_ifs23019/data/services/dessert_repository.dart';
import 'package:pam_p7_2026_ifs23019/features/desserts/desserts_screen.dart';
import 'package:pam_p7_2026_ifs23019/providers/dessert_provider.dart';

class MockDessertRepository extends DessertRepository {
  final List<DessertModel> desserts;
  MockDessertRepository(this.desserts);

  @override
  Future<ApiResponse<List<DessertModel>>> getDesserts({String search = ''}) async =>
      ApiResponse(success: true, message: 'OK', data: desserts);
}

Widget buildDessertsScreenTest(List<DessertModel> desserts) {
  final notifier = ThemeNotifier(initial: ThemeMode.light);
  final provider = DessertProvider(
    // Kita panggil .toList() agar datanya tidak unmodifiable (mencegah crash)
    repository: MockDessertRepository(desserts.toList()),
  );

  final router = GoRouter(
    initialLocation: '/desserts',
    routes: [
      GoRoute(
        path: '/desserts',
        builder: (_, __) => const DessertsScreen(),
      ),
      GoRoute(path: '/desserts/:id', builder: (_, __) => const SizedBox()),
      GoRoute(path: '/desserts/add', builder: (_, __) => const SizedBox()),
    ],
  );

  return ThemeProvider(
    notifier: notifier,
    child: ChangeNotifierProvider.value(
      value: provider,
      child: MaterialApp.router(
        theme: AppTheme.lightTheme,
        routerConfig: router,
      ),
    ),
  );
}

void main() {
  final testDesserts = [
    const DessertModel(
        id: 'uuid-klepon',
        nama: 'Klepon',
        gambar: 'https://host/static/desserts/klepon.png',
        deskripsi: 'Bola-bola ketan isi gula merah.',
        bahanUtama: 'Tepung ketan, gula merah, kelapa.',
        kategori: 'Traditional'),
    const DessertModel(
        id: 'uuid-brownies',
        nama: 'Brownies',
        gambar: 'https://host/static/desserts/brownies.png',
        deskripsi: 'Kue cokelat panggang yang legit.',
        bahanUtama: 'Cokelat, telur, tepung, mentega.',
        kategori: 'Cake'),
  ];

  group('DessertsScreen Widget Test', () {
    testWidgets('menampilkan daftar dessert dari API Mock', (tester) async {
      await tester.pumpWidget(buildDessertsScreenTest(testDesserts));
      // Kita gunakan pump beberapa kali agar status loading selesai
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Klepon'), findsOneWidget);
      expect(find.text('Brownies'), findsOneWidget);
      expect(find.text('Traditional'), findsOneWidget);
    });

    testWidgets('menampilkan pesan kosong ketika tidak ada dessert', (tester) async {
      await tester.pumpWidget(buildDessertsScreenTest([]));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Daftar dessert masih kosong nih!'), findsOneWidget);
      expect(find.byIcon(Icons.cookie_outlined), findsOneWidget);
    });

    testWidgets('menampilkan tombol FAB dengan ikon add shopping cart', (tester) async {
      await tester.pumpWidget(buildDessertsScreenTest(testDesserts));
      await tester.pump();

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add_shopping_cart_outlined), findsOneWidget);
    });

    testWidgets('menampilkan search icon di AppBar', (tester) async {
      await tester.pumpWidget(buildDessertsScreenTest(testDesserts));
      await tester.pump();

      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('menampilkan badge kategori pada setiap item', (tester) async {
      await tester.pumpWidget(buildDessertsScreenTest(testDesserts));
      await tester.pump();

      expect(find.text('Cake'), findsOneWidget);
    });
  });
}