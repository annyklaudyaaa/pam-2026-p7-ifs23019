// lib/features/desserts/desserts_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/route_constants.dart';
import '../../providers/dessert_provider.dart';
import '../../shared/widgets/error_widget.dart';
import '../../shared/widgets/loading_widget.dart';
import '../../shared/widgets/top_app_bar_widget.dart';
import '../../data/models/dessert_model.dart';

class DessertsDetailScreen extends StatefulWidget {
  const DessertsDetailScreen({super.key, required this.dessertId});

  final String dessertId;

  @override
  State<DessertsDetailScreen> createState() => _DessertsDetailScreenState();
}

class _DessertsDetailScreenState extends State<DessertsDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DessertProvider>().loadDessertById(widget.dessertId);
    });
  }

  Future<void> _confirmDelete(
      BuildContext context, DessertProvider provider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Menu Dessert'),
        content:
        const Text('Yakin mau menghapus menu manis ini dari daftar? 🥺'),
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
      final success = await provider.removeDessert(widget.dessertId);
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Menu dessert berhasil dihapus.')),
        );
        context.go(RouteConstants.desserts);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DessertProvider>(
      builder: (context, provider, _) {
        if (provider.status == DessertStatus.loading ||
            provider.status == DessertStatus.initial) {
          return const Scaffold(
            appBar: TopAppBarWidget(
              title: 'Detail Dessert',
              showBackButton: true,
            ),
            body: LoadingWidget(),
          );
        }

        if (provider.status == DessertStatus.error) {
          return Scaffold(
            appBar: const TopAppBarWidget(
              title: 'Detail Dessert',
              showBackButton: true,
            ),
            body: AppErrorWidget(
              message: provider.errorMessage,
              onRetry: () => provider.loadDessertById(widget.dessertId),
            ),
          );
        }

        final dessert = provider.selectedDessert;
        if (dessert == null) {
          return const Scaffold(
            appBar: TopAppBarWidget(
              title: 'Detail Dessert',
              showBackButton: true,
            ),
            body: Center(child: Text('Duh, datanya nggak ketemu nih.')),
          );
        }

        return Scaffold(
          appBar: TopAppBarWidget(
            title: dessert.nama,
            showBackButton: true,
            menuItems: [
              TopAppBarMenuItem(
                text: 'Edit',
                icon: Icons.edit_note_outlined,
                onTap: () async {
                  final edited = await context.push<bool>(
                    RouteConstants.dessertsEdit(dessert.id!),
                  );
                  if (edited == true && context.mounted) {
                    provider.loadDessertById(widget.dessertId);
                  }
                },
              ),
              TopAppBarMenuItem(
                text: 'Hapus',
                icon: Icons.delete_sweep_outlined,
                isDestructive: true,
                onTap: () => _confirmDelete(context, provider),
              ),
            ],
          ),
          body: _DessertsDetailBody(dessert: dessert),
        );
      },
    );
  }
}

class _DessertsDetailBody extends StatelessWidget {
  const _DessertsDetailBody({required this.dessert});

  final DessertModel dessert;

  @override
  Widget build(BuildContext context) {
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
                    dessert.gambar,
                    width: double.infinity,
                    height: 280,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 280,
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: Icon(
                        Icons.cake_outlined,
                        size: 80,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  dessert.nama,
                  style:
                  Theme.of(context).textTheme.headlineMedium?.copyWith(
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
            content: dessert.deskripsi,
            icon: Icons.description_outlined,
          ),
          const SizedBox(height: 16),
          // UPDATE: Gunakan bahanUtama
          _InfoCard(
            title: 'Bahan Utama',
            content: dessert.bahanUtama,
            icon: Icons.restaurant_outlined,
          ),
          const SizedBox(height: 16),
          // UPDATE: Gunakan kategori
          _InfoCard(
            title: 'Kategori Menu',
            content: dessert.kategori,
            icon: Icons.category_outlined,
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
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.5,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}