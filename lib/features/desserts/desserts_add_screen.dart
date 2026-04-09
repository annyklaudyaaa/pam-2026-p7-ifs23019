// lib/features/desserts/desserts_add_screen.dart

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/dessert_provider.dart';
import '../../shared/widgets/top_app_bar_widget.dart';

class DessertsAddScreen extends StatefulWidget {
  const DessertsAddScreen({super.key});

  @override
  State<DessertsAddScreen> createState() => _DessertsAddScreenState();
}

class _DessertsAddScreenState extends State<DessertsAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _bahanUtamaController = TextEditingController(); // UPDATE: Sesuai BE
  final _kategoriController = TextEditingController();    // UPDATE: Sesuai BE

  File? _imageFile;
  Uint8List? _imageBytes;
  String _imageFilename = 'dessert.jpg';
  bool _isLoading = false;

  bool get _hasImage => _imageBytes != null;

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    _bahanUtamaController.dispose();
    _kategoriController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 1024,
    );
    if (picked == null) return;

    final bytes = await picked.readAsBytes();
    setState(() {
      _imageBytes = bytes;
      _imageFilename = picked.name;
      _imageFile = kIsWeb ? null : File(picked.path);
    });
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Pilih dari Galeri'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
            if (!kIsWeb)
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Ambil Foto'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.camera);
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_hasImage) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih gambar dessert dulu ya! 🍰')),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Pastikan parameter di provider addDessert juga sudah diganti
    // menjadi bahanUtama dan kategori
    final success = await context.read<DessertProvider>().addDessert(
      nama: _namaController.text.trim(),
      deskripsi: _deskripsiController.text.trim(),
      bahanUtama: _bahanUtamaController.text.trim(), // UPDATE
      kategori: _kategoriController.text.trim(),     // UPDATE
      imageFile: _imageFile,
      imageBytes: _imageBytes,
      imageFilename: _imageFilename,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Yash! Dessert berhasil ditambah.')),
      );
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.read<DessertProvider>().errorMessage),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const TopAppBarWidget(
        title: 'Tambah Dessert',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _showImageSourceSheet,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colorScheme.outline, width: 1),
                  ),
                  child: _hasImage
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.memory(
                      _imageBytes!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  )
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cake_outlined,
                          size: 48, color: colorScheme.primary),
                      const SizedBox(height: 8),
                      Text(
                        'Upload Foto Dessert Kamu',
                        style: TextStyle(color: colorScheme.primary),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              _buildField(
                controller: _namaController,
                label: 'Nama Dessert',
                hint: 'Contoh: Red Velvet Cake',
                icon: Icons.restaurant_menu_outlined,
              ),
              const SizedBox(height: 16),
              _buildField(
                controller: _deskripsiController,
                label: 'Deskripsi',
                hint: 'Ceritain sedikit tentang dessert ini...',
                icon: Icons.notes_outlined,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              _buildField(
                controller: _bahanUtamaController,
                label: 'Bahan Utama', // UPDATE Label
                hint: 'Contoh: Tepung terigu, Cokelat, Gula',
                icon: Icons.egg_outlined,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              _buildField(
                controller: _kategoriController,
                label: 'Kategori', // UPDATE Label
                hint: 'Contoh: Cake, Pastry, Cold Dessert',
                icon: Icons.category_outlined, // Ikon disesuaikan
              ),
              const SizedBox(height: 32),

              FilledButton.icon(
                onPressed: _isLoading ? null : _submit,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: colorScheme.primary,
                ),
                icon: _isLoading
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
                    : const Icon(Icons.check_circle_outline),
                label: Text(_isLoading ? 'Sedang Memasak...' : 'Simpan Menu'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label wajib diisi ya.';
        }
        return null;
      },
    );
  }
}