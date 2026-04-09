// lib/core/constants/api_constants.dart

/// Konstanta untuk konfigurasi API
class ApiConstants {
  ApiConstants._();

  /// Base URL API Delcom Plants & Desserts
  static const String baseUrl =
      'https://pam-2026-p4-ifs23019-be.annyklaudya.site:8080';

  /* -------------------------
     PLANTS ENDPOINTS
  -------------------------- */
  static const String plants = '/plants';
  static String plantById(String id) => '/plants/$id';

  /// TAMBAHKAN INI: Endpoint untuk ambil gambar tanaman
  static String plantImage(String id) => '/plants/$id/image';

  /* -------------------------
     DESSERTS ENDPOINTS
  -------------------------- */
  static const String desserts = '/desserts';
  static String dessertById(String id) => '/desserts/$id';

  /// TAMBAHKAN INI: Endpoint untuk ambil gambar dessert
  static String dessertImage(String id) => '/desserts/$id/image';
}