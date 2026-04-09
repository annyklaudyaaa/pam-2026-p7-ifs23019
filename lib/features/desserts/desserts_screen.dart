// lib/features/desserts/desserts_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/route_constants.dart';
import '../../data/models/dessert_model.dart';
import '../../providers/dessert_provider.dart';
import '../../shared/widgets/error_widget.dart';
import '../../shared/widgets/loading_widget.dart';
import '../../shared/widgets/top_app_bar_widget.dart';

class DessertsScreen extends StatefulWidget {
  const DessertsScreen({super.key});

  @override
  State<DessertsScreen> createState() => _DessertsScreenState();
}

class _DessertsScreenState extends State<DessertsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DessertProvider>().loadDesserts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DessertProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: TopAppBarWidget(
            title: 'Desserts 🍰',
            withSearch: true,
            searchQuery: provider.searchQuery,
            onSearchQueryChange: provider.updateSearchQuery,
          ),
          body: _buildBody(provider),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final added = await context.push<bool>(RouteConstants.dessertsAdd);
              if (added == true && context.mounted) {
                provider.loadDesserts();
              }
            },
            tooltip: 'Tambah Dessert',
            backgroundColor: Theme.of(context).colorScheme.primary, // Biar makin cantik
            child: const Icon(Icons.add_shopping_cart_outlined, color: Colors.white),
          ),
        );
      },
    );
  }

  Widget _buildBody(DessertProvider provider) {
    return switch (provider.status) {
      DessertStatus.loading || DessertStatus.initial => const LoadingWidget(),
      DessertStatus.error => AppErrorWidget(
        message: provider.errorMessage,
        onRetry: () => provider.loadDesserts(),
      ),
      DessertStatus.success => _DessertsBody(
        desserts: provider.desserts,
        onOpen: (id) => context.push(RouteConstants.dessertsDetail(id)),
      ),
    };
  }
}

class _DessertsBody extends StatelessWidget {
  const _DessertsBody({required this.desserts, required this.onOpen});

  final List<DessertModel> desserts;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    if (desserts.isEmpty) {
      return Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.cookie_outlined, size: 48, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'Daftar dessert masih kosong nih!',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<DessertProvider>().loadDesserts(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: desserts.length,
        itemBuilder: (context, index) {
          return _DessertItemCard(
            dessert: desserts[index],
            onOpen: onOpen,
          );
        },
      ),
    );
  }
}

class _DessertItemCard extends StatelessWidget {
  const _DessertItemCard({required this.dessert, required this.onOpen});

  final DessertModel dessert;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => onOpen(dessert.id!),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Hero(
                tag: 'dessert-${dessert.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    dessert.gambar,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80,
                      height: 80,
                      color: colorScheme.primaryContainer.withOpacity(0.5),
                      child: Icon(Icons.cake_outlined, color: colorScheme.primary),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dessert.nama,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dessert.deskripsi,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // UPDATE: Badge Kategori (Ganti dari dessert.kalori)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        dessert.kategori, // GANTI DISINI
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSecondaryContainer,
                        ),
                      ),
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