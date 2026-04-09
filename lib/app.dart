// lib/app.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_notifier.dart';
import 'providers/plant_provider.dart';
import 'providers/dessert_provider.dart'; // IMPORT BARU: DessertProvider

class DelcomApp extends StatefulWidget {
  const DelcomApp({super.key});

  @override
  State<DelcomApp> createState() => _DelcomAppState();
}

class _DelcomAppState extends State<DelcomApp> {
  final ThemeNotifier _themeNotifier = ThemeNotifier(initial: ThemeMode.light);

  @override
  void dispose() {
    _themeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      notifier: _themeNotifier,
      // MultiProvider sekarang menampung kedua "otak" aplikasi
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => PlantProvider()),
          ChangeNotifierProvider(create: (_) => DessertProvider()), // TAMBAHKAN INI
        ],
        child: ValueListenableBuilder<ThemeMode>(
          valueListenable: _themeNotifier,
          builder: (context, themeMode, child) {
            return MaterialApp.router(
              title: 'Delcom Plants & Desserts', // Judul baru yang lebih lengkap
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
              routerConfig: appRouter,
              debugShowCheckedModeBanner: false,
            );
          },
        ),
      ),
    );
  }
}