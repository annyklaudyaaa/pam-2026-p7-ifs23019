// lib/core/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    textTheme: AppTypography.textTheme,

    scaffoldBackgroundColor: kLightSurface,
    // Customization tambahan agar lebih "manis"
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: kLightSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    // PENTING: const dihapus karena BorderRadius.circular bukan konstanta
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: kLightSurface,
    ),
    colorScheme: const ColorScheme.light(
      primary: kLightPrimary,
      onPrimary: kLightOnPrimary,
      primaryContainer: kLightPrimaryContainer,
      onPrimaryContainer: kLightOnPrimaryContainer,
      secondary: kLightSecondary,
      onSecondary: kLightOnSecondary,
      secondaryContainer: kLightSecondaryContainer,
      onSecondaryContainer: kLightOnSecondaryContainer,
      tertiary: kLightTertiary,
      onTertiary: kLightOnTertiary,
      error: kLightError,
      onError: kLightOnError,
      errorContainer: kLightErrorContainer,
      onErrorContainer: kLightOnErrorContainer,
      surface: kLightSurface,
      onSurface: kLightOnSurface,
      surfaceContainerHighest: kLightSurfaceVariant,
      onSurfaceVariant: kLightOnSurfaceVariant,
      outline: kLightOutline,
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    textTheme: AppTypography.textTheme,
    scaffoldBackgroundColor: kDarkSurface,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
    ),
    // PENTING: const dihapus di sini juga
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    colorScheme: const ColorScheme.dark(
      primary: kDarkPrimary,
      onPrimary: kDarkOnPrimary,
      primaryContainer: kDarkPrimaryContainer,
      onPrimaryContainer: kDarkOnPrimaryContainer,
      secondary: kDarkSecondary,
      onSecondary: kDarkOnSecondary,
      secondaryContainer: kDarkSecondaryContainer,
      onSecondaryContainer: kDarkOnSecondaryContainer,
      tertiary: kDarkTertiary,
      onTertiary: kDarkOnTertiary,
      error: kDarkError,
      onError: kDarkOnError,
      errorContainer: kDarkErrorContainer,
      onErrorContainer: kDarkOnErrorContainer,
      surface: kDarkSurface,
      onSurface: kDarkOnSurface,
      surfaceContainerHighest: kDarkSurfaceVariant,
      onSurfaceVariant: kDarkOnSurfaceVariant,
      outline: kDarkOutline,
    ),
  );
}