// lib/features/plants/plants_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/route_constants.dart';
import '../../providers/plant_provider.dart';
import '../../shared/widgets/error_widget.dart';
import '../../shared/widgets/loading_widget.dart';
import '../../shared/widgets/top_app_bar_widget.dart';
import '../../data/models/plant_model.dart';

class PlantsDetailScreen extends StatefulWidget {
  const PlantsDetailScreen({super.key, required this.plantId});

  final String plantId;

  @override
  State<PlantsDetailScreen> createState() => _PlantsDetailScreenState();
}

class _PlantsDetailScreenState extends State<PlantsDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlantProvider>().loadPlantById(widget.plantId);
    });
  }

  Future<void> _confirmDelete(
      BuildContext context, PlantProvider provider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Tanaman'),
        content:
        const Text('Apakah kamu yakin ingin menghapus tanaman ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final success = await provider.removePlant(widget.plantId);
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tanaman berhasil dihapus.')),
        );
        context.go(RouteConstants.plants);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlantProvider>(
      builder: (context, provider, _) {
        if (provider.status == PlantStatus.loading ||
            provider.status == PlantStatus.initial) {
          return const Scaffold(
            appBar: TopAppBarWidget(
              title: 'Detail Tanaman',
              showBackButton: true,
            ),
            body: LoadingWidget(),
          );
        }

        if (provider.status == PlantStatus.error) {
          return Scaffold(
            appBar: const TopAppBarWidget(
              title: 'Detail Tanaman',
              showBackButton: true,
            ),
            body: AppErrorWidget(
              message: provider.errorMessage,
              onRetry: () => provider.loadPlantById(widget.plantId),
            ),
          );
        }

        final plant = provider.selectedPlant;
        if (plant == null) {
          return const Scaffold(
            appBar: TopAppBarWidget(
              title: 'Detail Tanaman',
              showBackButton: true,
            ),
            body: Center(child: Text('Data tidak ditemukan.')),
          );
        }

        return Scaffold(
          appBar: TopAppBarWidget(
            title: plant.nama,
            showBackButton: true,
            menuItems: [
              TopAppBarMenuItem(
                text: 'Edit',
                icon: Icons.edit_outlined,
                onTap: () async {
                  final edited = await context.push<bool>(
                    RouteConstants.plantsEdit(plant.id!),
                  );
                  // Jika berhasil edit, kita muat ulang datanya
                  if (edited == true && context.mounted) {
                    provider.loadPlantById(widget.plantId);
                  }
                },
              ),
              TopAppBarMenuItem(
                text: 'Hapus',
                icon: Icons.delete_outline,
                isDestructive: true,
                onTap: () => _confirmDelete(context, provider),
              ),
            ],
          ),
          body: _PlantsDetailBody(plant: plant),
        );
      },
    );
  }
}

class _PlantsDetailBody extends StatelessWidget {
  const _PlantsDetailBody({required this.plant});

  final PlantModel plant;

  @override
  Widget build(BuildContext context) {
    // TRIK CACHE BUSTING: Tambahkan parameter waktu di belakang URL
    // Agar Flutter menganggap ini URL baru dan mengambil gambar segar dari server
    final String freshImageUrl = "${plant.gambar}?v=${DateTime.now().millisecondsSinceEpoch}";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    freshImageUrl, // Gunakan URL yang sudah ditambah timestamp
                    width: double.infinity,
                    height: 280,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 280,
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: Icon(
                        Icons.eco,
                        size: 80,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  plant.nama,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          _InfoCard(
            title: 'Deskripsi',
            content: plant.deskripsi,
            icon: Icons.description_outlined,
          ),
          const SizedBox(height: 16),
          _InfoCard(
            title: 'Manfaat',
            content: plant.manfaat,
            icon: Icons.eco_outlined,
          ),
          const SizedBox(height: 16),
          _InfoCard(
            title: 'Efek Samping',
            content: plant.efekSamping,
            icon: Icons.warning_amber_outlined,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.content,
    required this.icon,
  });

  final String title;
  final String content;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: colorScheme.primary, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}