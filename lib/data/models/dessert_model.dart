// lib/data/models/dessert_model.dart

import '../../core/constants/api_constants.dart';

/// Model data untuk dessert
class DessertModel {
  const DessertModel({
    this.id,
    required this.nama,
    this.gambar = '',
    this.pathGambar = '',
    required this.deskripsi,
    required this.bahanUtama,
    required this.kategori,
  });

  final String? id;
  final String nama;
  final String gambar;
  final String pathGambar;
  final String deskripsi;
  final String bahanUtama;
  final String kategori;

  /// Membuat DessertModel dari JSON (response API)
  factory DessertModel.fromJson(Map<String, dynamic> json) {
    final String dessertId = json['id'] as String? ?? '';

    // KUNCI: Kita susun URL gambar berdasarkan rute di Ktor kamu
    // Hasilnya: https://...site:8080/desserts/{id}/image
    final String imageUrl = dessertId.isNotEmpty
        ? '${ApiConstants.baseUrl}${ApiConstants.desserts}/$dessertId/image'
        : '';

    return DessertModel(
      id: dessertId,
      nama: json['nama'] as String? ?? '',
      gambar: imageUrl, // URL ini yang akan dipakai Image.network
      pathGambar: json['pathGambar'] as String? ?? '',
      deskripsi: json['deskripsi'] as String? ?? '',
      bahanUtama: json['bahanUtama'] as String? ?? '',
      kategori: json['kategori'] as String? ?? '',
    );
  }

  /// Metode copyWith
  DessertModel copyWith({
    String? id,
    String? nama,
    String? gambar,
    String? pathGambar,
    String? deskripsi,
    String? bahanUtama,
    String? kategori,
  }) {
    return DessertModel(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      gambar: gambar ?? this.gambar,
      pathGambar: pathGambar ?? this.pathGambar,
      deskripsi: deskripsi ?? this.deskripsi,
      bahanUtama: bahanUtama ?? this.bahanUtama,
      kategori: kategori ?? this.kategori,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is DessertModel &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'DessertModel(id: $id, nama: $nama)';
}