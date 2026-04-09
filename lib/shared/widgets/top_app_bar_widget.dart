import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/route_constants.dart';
import '../../core/theme/theme_notifier.dart';

/// Model untuk item menu di dropdown TopAppBar
class TopAppBarMenuItem {
  const TopAppBarMenuItem({
    required this.text,
    required this.icon,
    this.route,
    this.onTap,
    this.isDestructive = false,
  });

  final String text;
  final IconData icon;
  final String? route;
  final VoidCallback? onTap;
  final bool isDestructive;
}

/// Widget Top App Bar yang dapat mendeteksi tema (Plants/Desserts) secara dinamis
class TopAppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  const TopAppBarWidget({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.withSearch = false,
    this.searchQuery = '',
    this.onSearchQueryChange,
    this.menuItems = const [],
  });

  final String title;
  final bool showBackButton;
  final bool withSearch;
  final String searchQuery;
  final ValueChanged<String>? onSearchQueryChange;
  final List<TopAppBarMenuItem> menuItems;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<TopAppBarWidget> createState() => _TopAppBarWidgetState();
}

class _TopAppBarWidgetState extends State<TopAppBarWidget> {
  bool _isSearchActive = false;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Menentukan Hint Text berdasarkan judul halaman
  String _getSearchHint() {
    if (widget.title.toLowerCase().contains('dessert')) {
      return 'Cari dessert manis... 🍰';
    }
    return 'Cari tanaman... 🌱';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final themeNotifier = ThemeProvider.of(context);
    final isDark = themeNotifier.isDark;

    // Deteksi apakah ini halaman dessert untuk pewarnaan teks
    final isDessertPage = widget.title.toLowerCase().contains('dessert');

    return AppBar(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shadowColor: colorScheme.shadow.withValues(alpha: 0.5),
      scrolledUnderElevation: 4,

      // --- Tombol Navigasi Kiri (Back) ---
      leading: widget.showBackButton
          ? IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 20), // Versi lebih modern
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(RouteConstants.home);
          }
        },
      )
          : null,

      // --- Bagian Tengah: Judul atau Kolom Pencarian ---
      title: _isSearchActive
          ? TextField(
        controller: _searchController,
        autofocus: true,
        style: TextStyle(color: colorScheme.onSurface),
        decoration: InputDecoration(
          hintText: _getSearchHint(),
          border: InputBorder.none,
          hintStyle: TextStyle(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            fontSize: 16,
          ),
        ),
        onChanged: widget.onSearchQueryChange,
      )
          : Text(
        widget.title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: isDessertPage ? colorScheme.primary : colorScheme.onSurface,
        ),
      ),

      // --- Bagian Kanan: Actions (Theme Toggle, Search, Menu) ---
      actions: [
        // 1. Toggle Dark/Light Mode dengan Animasi Rotasi
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (child, animation) => RotationTransition(
            turns: animation,
            child: FadeTransition(opacity: animation, child: child),
          ),
          child: IconButton(
            key: ValueKey(isDark),
            icon: Icon(
              isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              color: isDark ? Colors.amberAccent : colorScheme.primary,
            ),
            tooltip: isDark ? 'Mode Gelap' : 'Mode Terang',
            onPressed: themeNotifier.toggle,
          ),
        ),

        // 2. Tombol Search (Jika diaktifkan)
        if (widget.withSearch)
          IconButton(
            icon: Icon(_isSearchActive ? Icons.close : Icons.search),
            onPressed: () {
              setState(() => _isSearchActive = !_isSearchActive);
              if (!_isSearchActive) {
                _searchController.clear();
                widget.onSearchQueryChange?.call('');
              }
            },
          ),

        // 3. Popup Menu (Jika ada menu items)
        if (widget.menuItems.isNotEmpty)
          PopupMenuButton<TopAppBarMenuItem>(
            icon: const Icon(Icons.more_vert),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: colorScheme.surfaceContainerHighest,
            itemBuilder: (context) => widget.menuItems.map((item) {
              return PopupMenuItem<TopAppBarMenuItem>(
                value: item,
                child: Row(
                  children: [
                    Icon(
                      item.icon,
                      size: 20,
                      color: item.isDestructive ? colorScheme.error : colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      item.text,
                      style: TextStyle(
                        color: item.isDestructive ? colorScheme.error : colorScheme.onSurface,
                        fontWeight: item.isDestructive ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onSelected: (item) {
              if (item.route != null) context.go(item.route!);
              item.onTap?.call();
            },
          ),
        const SizedBox(width: 4),
      ],
    );
  }
}