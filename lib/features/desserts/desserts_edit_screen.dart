// lib/features/desserts/desserts_edit_screen.dart

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../data/models/dessert_model.dart';
import '../../providers/dessert_provider.dart';
import '../../shared/widgets/top_app_bar_widget.dart';

class DessertsEditScreen extends StatefulWidget {
  const DessertsEditScreen({super.key, required this.dessertId});

  final String dessertId;

  @override
  State<DessertsEditScreen> createState() => _DessertsEditScreenState();
}

class _DessertsEditScreenState extends State<DessertsEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _bahanUtamaController = TextEditingController(); // UPDATE: Sesuai BE
  final _kategoriController = TextEditingController();    // UPDATE: Sesuai BE

  File? _newImageFile;
  Uint8List? _newImageBytes;
  String _newImageFilename = 'dessert.jpg';
  bool _isLoading = false;
  bool _isInitialized = false;

  bool get _hasNewImage => _newImageBytes != null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isInitialized) {
        context.read<DessertProvider>().loadDessertById(widget.dessertId);
      }
    });
  }

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    _bahanUtamaController.dispose();
    _kategoriController.dispose();
    super.dispose();
  }

  void _populateForm(DessertModel dessert) {
    if (_isInitialized) return;
    _namaController.text = dessert.nama;
    _deskripsiController.text = dessert.deskripsi;
    _bahanUtamaController.text = dessert.bahanUtama; // UPDATE
    _kategoriController.text = dessert.kategori;     // UPDATE
    _isInitialized = true;
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
      _newImageBytes = bytes;
      _newImageFilename = picked.name;
      _newImageFile = kIsWeb ? null : File(picked.path);
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

  Future<void> _submit(DessertModel original) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Pastikan di DessertProvider fungsi ini juga sudah menggunakan
    // parameter bahanUtama dan kategori
    final success = await context.read<DessertProvider>().editDessert(
      id: original.id!,
      nama: _namaController.text.trim(),
      deskripsi: _deskripsiController.text.trim(),
      bahanUtama: _bahanUtamaController.text.trim(), // UPDATE
      kategori: _kategoriController.text.trim(),     // UPDATE
      imageFile: _newImageFile,
      imageBytes: _newImageBytes,
      imageFilename: _newImageFilename,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Yippie! Perubahan berhasil disimpan. ✨')),
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

    return Consumer<DessertProvider>(
      builder: (context, provider, _) {
        final dessert = provider.selectedDessert;

        if (dessert != null) _populateForm(dessert);

        return Scaffold(
          appBar: const TopAppBarWidget(
            title: 'Edit Menu Dessert',
            showBackButton: true,
          ),
          body: dessert == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
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
                        border: Border.all(color: colorScheme.outline),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            _hasNewImage
                                ? Image.memory(
                              _newImageBytes!,
                              fit: BoxFit.cover,
                            )
                                : Image.network(
                              dessert.gambar,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.cake_outlined,
                                size: 48,
                                color: colorScheme.primary,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                color: Colors.black54,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8),
                                child: const Text(
                                  'Ketuk untuk ganti foto dessert',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildField(
                    controller: _namaController,
                    label: 'Nama Dessert',
                    icon: Icons.restaurant_menu_outlined,
                  ),
                  const SizedBox(height: 16),
                  _buildField(
                    controller: _deskripsiController,
                    label: 'Deskripsi',
                    icon: Icons.notes_outlined,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  // UPDATE Label dan Controller
                  _buildField(
                    controller: _bahanUtamaController,
                    label: 'Bahan Utama',
                    icon: Icons.egg_outlined,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  // UPDATE Label dan Controller
                  _buildField(
                    controller: _kategoriController,
                    label: 'Kategori Menu',
                    icon: Icons.category_outlined,
                  ),
                  const SizedBox(height: 32),

                  FilledButton.icon(
                    onPressed: _isLoading ? null : () => _submit(dessert),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      backgroundColor: colorScheme.primary,
                    ),
                    icon: _isLoading
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                        : const Icon(Icons.save_as_outlined),
                    label:
                    Text(_isLoading ? 'Menyimpan...' : 'Simpan Perubahan'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label jangan dikosongin ya.';
        }
        return null;
      },
    );
  }
}