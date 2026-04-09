// test/unit/dessert_provider_test.dart

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:pam_p7_2026_ifs23019/data/models/api_response_model.dart';
import 'package:pam_p7_2026_ifs23019/data/models/dessert_model.dart';
import 'package:pam_p7_2026_ifs23019/data/services/dessert_repository.dart';
import 'package:pam_p7_2026_ifs23019/providers/dessert_provider.dart';

/// Repository palsu (mock) untuk keperluan pengujian Dessert
class MockDessertRepository extends DessertRepository {
  MockDessertRepository({
    required this.mockDesserts,
    this.shouldFail = false,
  });

  final List<DessertModel> mockDesserts;
  final bool shouldFail;

  @override
  Future<ApiResponse<List<DessertModel>>> getDesserts({String search = ''}) async {
    if (shouldFail) {
      return const ApiResponse(
        success: false,
        message: 'Gagal terhubung ke server toko kue.',
      );
    }
    return ApiResponse(success: true, message: 'OK', data: mockDesserts);
  }

  @override
  Future<ApiResponse<String>> createDessert({
    required String nama,
    required String deskripsi,
    required String bahanUtama, // UPDATE
    required String kategori,    // UPDATE
    File? imageFile,
    Uint8List? imageBytes,
    String imageFilename = 'dessert.jpg',
  }) async {
    if (shouldFail) {
      return const ApiResponse(
        success: false,
        message: 'Gagal menambahkan menu manis.',
      );
    }
    return const ApiResponse(
      success: true,
      message: 'OK',
      data: 'new-dessert-uuid-999',
    );
  }

  @override
  Future<ApiResponse<void>> deleteDessert(String id) async {
    if (shouldFail) {
      return const ApiResponse(
        success: false,
        message: 'Gagal menghapus menu.',
      );
    }
    return const ApiResponse(success: true, message: 'OK');
  }
}

void main() {
  const testDesserts = [
    DessertModel(
        id: 'uuid-klepon',
        nama: 'Klepon',
        gambar: 'https://host/static/desserts/klepon.png',
        deskripsi: 'Manis legit',
        bahanUtama: 'Ketan, gula merah', // UPDATE
        kategori: 'Traditional'),        // UPDATE
    DessertModel(
        id: 'uuid-brownies',
        nama: 'Brownies',
        gambar: 'https://host/static/desserts/brownies.png',
        deskripsi: 'Nyoklat banget',
        bahanUtama: 'Cokelat, tepung',    // UPDATE
        kategori: 'Cake'),               // UPDATE
  ];

  group('DessertProvider Unit Test (Synced Version)', () {
    late DessertProvider provider;

    setUp(() {
      provider = DessertProvider(
        repository: MockDessertRepository(mockDesserts: testDesserts),
      );
    });

    test('status awal harus DessertStatus.initial', () {
      expect(provider.status, equals(DessertStatus.initial));
    });

    test('loadDesserts berhasil mengubah status ke success dan mengisi list', () async {
      await provider.loadDesserts();
      expect(provider.status, equals(DessertStatus.success));
      expect(provider.desserts.length, equals(2));
      expect(provider.desserts.first.nama, equals('Klepon'));
    });

    test('loadDesserts gagal akan mengubah status ke error', () async {
      provider = DessertProvider(
        repository: MockDessertRepository(
          mockDesserts: [],
          shouldFail: true,
        ),
      );
      await provider.loadDesserts();
      expect(provider.status, equals(DessertStatus.error));
      expect(provider.errorMessage, contains('Gagal terhubung'));
    });

    test('updateSearchQuery berhasil memfilter nama dessert (case insensitive)', () async {
      await provider.loadDesserts();
      provider.updateSearchQuery('KLEPON');
      expect(provider.desserts.length, equals(1));
      expect(provider.desserts.first.nama, equals('Klepon'));
    });

    test('removeDessert berhasil menghapus item dari list lokal', () async {
      await provider.loadDesserts();
      final success = await provider.removeDessert('uuid-brownies');

      expect(success, isTrue);
      expect(provider.desserts.any((d) => d.id == 'uuid-brownies'), isFalse);
      expect(provider.desserts.length, equals(1));
    });

    test('addDessert memicu pemuatan ulang data jika berhasil', () async {
      final success = await provider.addDessert(
        nama: 'Donat',
        deskripsi: 'Empuk',
        bahanUtama: 'Tepung, ragi', // UPDATE
        kategori: 'Pastry',         // UPDATE
      );

      expect(success, isTrue);
      expect(provider.status, equals(DessertStatus.success));
    });
  });
}