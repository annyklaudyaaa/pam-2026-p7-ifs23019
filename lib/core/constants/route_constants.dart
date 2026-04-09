// lib/core/constants/route_constants.dart

class RouteConstants {
  RouteConstants._();

  static const String home = '/';

  /// Routes untuk Plants
  static const String plants = '/plants';
  static const String plantsAdd = '/plants/add';
  static String plantsDetail(String id) => '/plants/$id';
  static String plantsEdit(String id) => '/plants/$id/edit';

  /// Routes untuk Desserts (Versi Baru)
  static const String desserts = '/desserts';
  static const String dessertsAdd = '/desserts/add';

  /// UUID sebagai path parameter untuk Dessert
  /// Contoh: /desserts/c0fe5a88-5178-42d3-9a11-834280a5231b
  static String dessertsDetail(String id) => '/desserts/$id';
  static String dessertsEdit(String id) => '/desserts/$id/edit';

  static const String profile = '/profile';
}