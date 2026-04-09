import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import '../data/models/dessert_model.dart';
import '../data/services/dessert_repository.dart';

enum DessertStatus { initial, loading, success, error }

class DessertProvider extends ChangeNotifier {
  DessertProvider({DessertRepository? repository})
      : _repository = repository ?? DessertRepository();

  final DessertRepository _repository;

  DessertStatus _status = DessertStatus.initial;
  List<DessertModel> _desserts = [];
  DessertModel? _selectedDessert;
  String _errorMessage = '';
  String _searchQuery = '';

  DessertStatus get status => _status;
  DessertModel? get selectedDessert => _selectedDessert;
  String get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  List<DessertModel> get desserts {
    if (_searchQuery.isEmpty) return List.unmodifiable(_desserts);
    return _desserts
        .where((d) => d.nama.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  Future<void> loadDesserts() async {
    _setStatus(DessertStatus.loading);
    final result = await _repository.getDesserts();
    if (result.success && result.data != null) {
      _desserts = result.data!.toList();
      _setStatus(DessertStatus.success);
    } else {
      _errorMessage = result.message;
      _setStatus(DessertStatus.error);
    }
  }

  Future<void> loadDessertById(String id) async {
    _setStatus(DessertStatus.loading);
    final result = await _repository.getDessertById(id);
    if (result.success && result.data != null) {
      _selectedDessert = result.data;
      _setStatus(DessertStatus.success);
    } else {
      _errorMessage = result.message;
      _setStatus(DessertStatus.error);
    }
  }

  Future<bool> addDessert({
    required String nama,
    required String deskripsi,
    required String bahanUtama,
    required String kategori,
    File? imageFile,
    Uint8List? imageBytes,
    String imageFilename = 'dessert.jpg',
  }) async {
    _setStatus(DessertStatus.loading);
    final result = await _repository.createDessert(
      nama: nama,
      deskripsi: deskripsi,
      bahanUtama: bahanUtama,
      kategori: kategori,
      imageFile: imageFile,
      imageBytes: imageBytes,
      imageFilename: imageFilename,
    );
    if (result.success) {
      await loadDesserts();
      return true;
    }
    _errorMessage = result.message;
    _setStatus(DessertStatus.error);
    return false;
  }

  Future<bool> editDessert({
    required String id,
    required String nama,
    required String deskripsi,
    required String bahanUtama,
    required String kategori,
    File? imageFile,
    Uint8List? imageBytes,
    String imageFilename = 'dessert.jpg',
  }) async {
    _setStatus(DessertStatus.loading);
    final result = await _repository.updateDessert(
      id: id,
      nama: nama,
      deskripsi: deskripsi,
      bahanUtama: bahanUtama,
      kategori: kategori,
      imageFile: imageFile,
      imageBytes: imageBytes,
      imageFilename: imageFilename,
    );
    if (result.success) {
      await loadDessertById(id);
      return true;
    }
    _errorMessage = result.message;
    _setStatus(DessertStatus.error);
    return false;
  }

  Future<bool> removeDessert(String id) async {
    _setStatus(DessertStatus.loading);
    final result = await _repository.deleteDessert(id);
    if (result.success) {
      _desserts.removeWhere((d) => d.id == id);
      _setStatus(DessertStatus.success);
      return true;
    }
    _errorMessage = result.message;
    _setStatus(DessertStatus.error);
    return false;
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSelectedDessert() {
    _selectedDessert = null;
    notifyListeners();
  }

  void _setStatus(DessertStatus status) {
    _status = status;
    notifyListeners(); // Sekarang memanggil fungsi asli
  }
}