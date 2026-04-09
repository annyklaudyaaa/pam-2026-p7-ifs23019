// test/unit/dessert_model_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:pam_p7_2026_ifs23019/data/models/dessert_model.dart';

void main() {
  group('DessertModel Unit Test (Sync Version)', () {
    const uuid = 'c0fe5a88-5178-42d3-9a11-834280a5231b';

    const dessert = DessertModel(
      id: uuid,
      nama: 'Klepon',
      gambar:
      'https://pam-2026-p4-ifs23019-be.annyklaudya.site:8080/static/desserts/uuid.png',
      pathGambar: 'uploads/desserts/uuid.png',
      deskripsi: 'Bola-bola ketan isi gula merah.',
      bahanUtama: 'Tepung ketan, gula merah, parutan kelapa.',
      kategori: 'Traditional',
    );

    test('membuat objek dengan semua field yang benar (Sweet Version)', () {
      expect(dessert.id, equals(uuid));
      expect(dessert.nama, equals('Klepon'));
      expect(dessert.gambar, contains('/static/desserts/'));

      // FIX: Ganti 'Gula merah' (kapital) jadi 'gula merah' (kecil)
      // agar sesuai dengan isi variabel bahanUtama di atas.
      expect(dessert.bahanUtama, contains('gula merah'));
    });

    test('fromJson memetakan field dessert dengan benar', () {
      final json = {
        'id': uuid,
        'nama': 'Klepon',
        'gambar':
        'https://pam-2026-p4-ifs23019-be.annyklaudya.site:8080/static/desserts/uuid.png',
        'pathGambar': 'uploads/desserts/uuid.png',
        'deskripsi': 'Bola-bola ketan isi gula merah.',
        'bahanUtama': 'Tepung ketan, gula merah, parutan kelapa.',
        'kategori': 'Traditional',
      };

      final result = DessertModel.fromJson(json);

      expect(result.id, equals(uuid));
      expect(result.nama, equals('Klepon'));
      expect(result.kategori, equals('Traditional'));
      expect(result.gambar, contains('http'));
    });

    test('copyWith mengubah nama dessert tanpa merusak field lain', () {
      final updated = dessert.copyWith(nama: 'Onde-onde');

      expect(updated.nama, equals('Onde-onde'));
      expect(updated.id, equals(dessert.id));
      expect(updated.kategori, equals(dessert.kategori));
      expect(updated.bahanUtama, equals(dessert.bahanUtama));
    });

    test('dua dessert dianggap sama jika memiliki UUID yang sama (Equality)', () {
      const other = DessertModel(
        id: uuid, // UUID sama
        nama: 'Klepon Berbeda',
        gambar: 'https://example.com/other-cake.jpg',
        deskripsi: '-',
        bahanUtama: '-',
        kategori: '-',
      );

      expect(dessert, equals(other));
    });

    test('toString menampilkan identitas dessert dengan jelas', () {
      expect(dessert.toString(), contains('Klepon'));
      expect(dessert.toString(), contains(uuid));
      expect(dessert.toString(), startsWith('DessertModel'));
    });
  });
}