// lib/features/plants/plants_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/route_constants.dart';
import '../../data/models/plant_model.dart';
import '../../providers/plant_provider.dart';
import '../../shared/widgets/error_widget.dart';
import '../../shared/widgets/loading_widget.dart';
import '../../shared/widgets/top_app_bar_widget.dart';

class PlantsScreen extends StatefulWidget {
  const PlantsScreen({super.key});

  @override
  State<PlantsScreen> createState() => _PlantsScreenState();
}

class _PlantsScreenState extends State<PlantsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlantProvider>().loadPlants();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlantProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          // Gunakan latar belakang dari tema agar tidak putih polos
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: TopAppBarWidget(
            title: 'Plants 🌿',
            withSearch: true,
            searchQuery: provider.searchQuery,
            onSearchQueryChange: provider.updateSearchQuery,
          ),
          body: _buildBody(provider),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final added = await context.push<bool>(RouteConstants.plantsAdd);
              if (added == true && context.mounted) {
                provider.loadPlants();
              }
            },
            tooltip: 'Tambah Tanaman',
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }

  Widget _buildBody(PlantProvider provider) {
    return switch (provider.status) {
      PlantStatus.loading || PlantStatus.initial => const LoadingWidget(),
      PlantStatus.error => AppErrorWidget(
        message: provider.errorMessage,
        onRetry: () => provider.loadPlants(),
      ),
      PlantStatus.success => _PlantsBody(
        plants: provider.plants,
        // Gunakan context.push agar user bisa kembali ke daftar setelah lihat detail
        onOpen: (id) => context.push(RouteConstants.plantsDetail(id)),
      ),
    };
  }
}

class _PlantsBody extends StatelessWidget {
  const _PlantsBody({required this.plants, required this.onOpen});

  final List<PlantModel> plants;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    if (plants.isEmpty) {
      return Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: const Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.eco_outlined, size: 48, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Daftar tanaman masih kosong nih! 🌱',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<PlantProvider>().loadPlants(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: plants.length,
        itemBuilder: (context, index) {
          return _PlantItemCard(
            plant: plants[index],
            onOpen: onOpen,
          );
        },
      ),
    );
  }
}

class _PlantItemCard extends StatelessWidget {
  const _PlantItemCard({required this.plant, required this.onOpen});

  final PlantModel plant;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // TRIK CACHE BUSTING: Tambahkan timestamp agar gambar list selalu update
    final String freshImageUrl = "${plant.gambar}?v=${DateTime.now().millisecondsSinceEpoch}";

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => onOpen(plant.id!),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  freshImageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 80,
                    height: 80,
                    color: colorScheme.primaryContainer.withOpacity(0.5),
                    child: Icon(Icons.eco, color: colorScheme.primary),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plant.nama,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      plant.deskripsi,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: colorScheme.outline),
            ],
          ),
        ),
      ),
    );
  }
}