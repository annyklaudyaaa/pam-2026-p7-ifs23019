// lib/data/services/dessert_service.dart

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import '../models/dessert_model.dart';
import '../models/api_response_model.dart';
import '../../core/constants/api_constants.dart';

class DessertService {
  DessertService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  /// Mengambil daftar semua dessert dari server
  Future<ApiResponse<List<DessertModel>>> getDesserts({String search = ''}) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.desserts}')
        .replace(queryParameters: search.isNotEmpty ? {'search': search} : null);

    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final dataMap = body['data'] as Map<String, dynamic>;
      final List<dynamic> jsonList = dataMap['desserts'] as List<dynamic>;
      final desserts = jsonList
          .map((e) => DessertModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiResponse(
        success: true,
        message: body['message'] as String? ?? 'Berhasil mengambil data.',
        data: desserts,
      );
    }

    return ApiResponse(success: false, message: _parseErrorMessage(response));
  }

  /// Mengambil detail satu dessert berdasarkan UUID
  Future<ApiResponse<DessertModel>> getDessertById(String id) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.dessertById(id)}');
    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final dataMap = body['data'] as Map<String, dynamic>;
      final dessert = DessertModel.fromJson(dataMap['dessert'] as Map<String, dynamic>);
      return ApiResponse(
        success: true,
        message: body['message'] as String? ?? 'Berhasil.',
        data: dessert,
      );
    }

    return ApiResponse(success: false, message: _parseErrorMessage(response));
  }

  /// Menambahkan dessert baru dengan upload gambar (Multipart)
  Future<ApiResponse<String>> createDessert({
    required String nama,
    required String deskripsi,
    required String bahanUtama, // UPDATE: Sesuai BE
    required String kategori,    // UPDATE: Sesuai BE
    File? imageFile,
    Uint8List? imageBytes,
    String imageFilename = 'dessert.jpg',
  }) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.desserts}');

    final request = http.MultipartRequest('POST', uri)
      ..fields['nama'] = nama
      ..fields['deskripsi'] = deskripsi
      ..fields['bahanUtama'] = bahanUtama // KUNCI: Harus 'bahanUtama' sesuai Ktor
      ..fields['kategori'] = kategori;    // KUNCI: Harus 'kategori' sesuai Ktor

    // Menangani upload file
    if (kIsWeb && imageBytes != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'file', imageBytes, filename: imageFilename,
      ));
    } else if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode == 201 || response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final dataMap = body['data'] as Map<String, dynamic>;
      return ApiResponse(
        success: true,
        message: body['message'] as String? ?? 'Dessert berhasil ditambahkan.',
        data: dataMap['dessertId'] as String,
      );
    }

    return ApiResponse(success: false, message: _parseErrorMessage(response));
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
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.dessertById(id)}');

    final request = http.MultipartRequest('PUT', uri)
      ..fields['nama'] = nama
      ..fields['deskripsi'] = deskripsi
      ..fields['bahanUtama'] = bahanUtama // KUNCI: Harus 'bahanUtama' sesuai Ktor
      ..fields['kategori'] = kategori;    // KUNCI: Harus 'kategori' sesuai Ktor

    if (kIsWeb && imageBytes != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'file', imageBytes, filename: imageFilename,
      ));
    } else if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return ApiResponse(
        success: true,
        message: body['message'] as String? ?? 'Dessert berhasil diperbarui.',
      );
    }

    return ApiResponse(success: false, message: _parseErrorMessage(response));
  }

  /// Menghapus dessert dari database
  Future<ApiResponse<void>> deleteDessert(String id) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.dessertById(id)}');
    final response = await _client.delete(uri);

    if (response.statusCode == 200 || response.statusCode == 204) {
      return const ApiResponse(success: true, message: 'Dessert berhasil dihapus.');
    }

    return ApiResponse(success: false, message: _parseErrorMessage(response));
  }

  String _parseErrorMessage(http.Response response) {
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return body['message'] as String? ?? 'Gagal. Kode: ${response.statusCode}';
    } catch (_) {
      return 'Gagal. Kode: ${response.statusCode}';
    }
  }

  void dispose() => _client.close();
}