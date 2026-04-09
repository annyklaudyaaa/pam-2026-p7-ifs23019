// lib/data/services/dessert_repository.dart

import 'dart:io';
import 'dart:typed_data';
import '../models/dessert_model.dart';
import '../models/api_response_model.dart';
import 'dessert_service.dart';

class DessertRepository {
  DessertRepository({DessertService? service})
      : _service = service ?? DessertService();

  final DessertService _service;

  /// Mengambil daftar semua dessert (dengan fitur pencarian)
  Future<ApiResponse<List<DessertModel>>> getDesserts({String search = ''}) async {
    try {
      return await _service.getDesserts(search: search);
    } catch (e) {
      return ApiResponse(success: false, message: 'Terjadi kesalahan jaringan: $e');
    }
  }

  /// Mengambil detail satu dessert berdasarkan ID
  Future<ApiResponse<DessertModel>> getDessertById(String id) async {
    try {
      return await _service.getDessertById(id);
    } catch (e) {
      return ApiResponse(success: false, message: 'Terjadi kesalahan jaringan: $e');
    }
  }

  /// Menambahkan data dessert baru ke server
  Future<ApiResponse<String>> createDessert({
    required String nama,
    required String deskripsi,
    required String bahanUtama, // UPDATE: Sesuai BE
    required String kategori,    // UPDATE: Sesuai BE
    File? imageFile,
    Uint8List? imageBytes,
    String imageFilename = 'dessert.jpg',
  }) async {
    try {
      return await _service.createDessert(
        nama: nama,
        deskripsi: deskripsi,
        bahanUtama: bahanUtama, // Sesuaikan kiriman ke service
        kategori: kategori,     // Sesuaikan kiriman ke service
        imageFile: imageFile,
        imageBytes: imageBytes,
        imageFilename: imageFilename,
      );
    } catch (e) {
      return ApiResponse(success: false, message: 'Terjadi kesalahan jaringan: $e');
    }
  }

  /// Memperbarui data dessert yang sudah ada
  Future<ApiResponse<void>> updateDessert({
    required String id,
    required String nama,
    required String deskripsi,
    required String bahanUtama, // UPDATE: Sesuai BE
    required String kategori,    // UPDATE: Sesuai BE
    File? imageFile,
    Uint8List? imageBytes,
    String imageFilename = 'dessert.jpg',
  }) async {
    try {
      return await _service.updateDessert(
        id: id,
        nama: nama,
        deskripsi: deskripsi,
        bahanUtama: bahanUtama, // Sesuaikan kiriman ke service
        kategori: kategori,     // Sesuaikan kiriman ke service
        imageFile: imageFile,
        imageBytes: imageBytes,
        imageFilename: imageFilename,
      );
    } catch (e) {
      return ApiResponse(success: false, message: 'Terjadi kesalahan jaringan: $e');
    }
  }

  /// Menghapus dessert berdasarkan ID
  Future<ApiResponse<void>> deleteDessert(String id) async {
    try {
      return await _service.deleteDessert(id);
    } catch (e) {
      return ApiResponse(success: false, message: 'Terjadi kesalahan jaringan: $e');
    }
  }
}