// lib/features/home/home_screen.dart

import 'package:flutter/material.dart';
import '../../shared/widgets/top_app_bar_widget.dart';
// Import app_colors jika ingin membedakan warna secara manual
import '../../core/theme/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopAppBarWidget(title: 'Home'),
      body: const SingleChildScrollView( // Tambahkan scroll agar tidak overflow jika layar kecil
        child: _HomeBody(),
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          /* =========================
             SECTION: DELCOM PLANTS
             ========================= */
          _buildBanner(
            context,
            title: '🌳 Delcom Plants 🌳',
            color: kPlantGreen, // Tetap pakai warna hijau asli tanaman
          ),
          const SizedBox(height: 12),
          _buildEmojiRow(context, ['🌱', '🌿', '🍃', '🥬']),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Divider(indent: 50, endIndent: 50, thickness: 1),
          ),

          /* =========================
             SECTION: DELCOM DESSERTS
             ========================= */
          _buildBanner(
            context,
            title: '🧁 Delcom Desserts 🧁',
            color: colorScheme.primary, // Pakai primary (Pink Strawberry)
          ),
          const SizedBox(height: 12),
          _buildEmojiRow(context, ['🍰', '🍩', '🍪', '🍦']),

          const SizedBox(height: 32),

          Text(
            "Halo Anny! Mau urus tanaman\natau cari yang manis-manis?",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widget untuk Banner agar kode lebih bersih
  Widget _buildBanner(BuildContext context, {required String title, required Color color}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // Helper Widget untuk Barisan Emoji
  Widget _buildEmojiRow(BuildContext context, List<String> emojis) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: emojis.map((emoji) {
        return Card(
          margin: const EdgeInsets.all(6),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 32),
            ),
          ),
        );
      }).toList(),
    );
  }
}