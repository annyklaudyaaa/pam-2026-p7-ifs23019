// lib/core/theme/app_colors.dart

import 'package:flutter/material.dart';

/* =========================
   BRAND COLORS (PLANT THEME)
   ========================= */
const Color kPlantGreen = Color(0xFF2E7D32);
const Color kPlantGreenLight = Color(0xFF4CAF50);
const Color kPlantGreenDark = Color(0xFF1B5E20);
const Color kPlantAccent = Color(0xFF8BC34A);

/* =========================
   BRAND COLORS (DESSERT THEME)
   ========================= */
const Color kDessertPink = Color(0xFFE91E63);       // Strawberry Pink
const Color kDessertPinkLight = Color(0xFFF06292);  // Pink lebih muda
const Color kDessertPinkDark = Color(0xFF880E4F);   // Warna Cherry/Berry gelap
const Color kDessertCream = Color(0xFFFFF9C4);      // Warna Cream/Vanilla
const Color kDessertChocolate = Color(0xFF6D4C41);  // Warna Cokelat untuk aksen

const Color kDelcomYellow = Color(0xFFFFC107);
const Color kDelcomYellowSoft = Color(0xFFFFE082);

/* =========================
   LIGHT THEME (MIXED/ADAPTIVE)
   ========================= */
// Kamu bisa memilih mau pakai Primary yang mana sebagai default
const Color kLightPrimary = kDessertPink;           // Sekarang kita pakai Pink sebagai warna utama
const Color kLightOnPrimary = Colors.white;
const Color kLightPrimaryContainer = Color(0xFFFFD8E4); // Container pink soft
const Color kLightOnPrimaryContainer = Color(0xFF31111D);

const Color kLightSecondary = kDelcomYellow;
const Color kLightOnSecondary = Color(0xFF2A1F00);
const Color kLightSecondaryContainer = kDelcomYellowSoft;
const Color kLightOnSecondaryContainer = Color(0xFF2A1F00);

const Color kLightTertiary = kDessertChocolate;    // Cokelat sebagai warna ketiga
const Color kLightOnTertiary = Colors.white;

const Color kLightError = Color(0xFFBA1A1A);
const Color kLightOnError = Colors.white;
const Color kLightErrorContainer = Color(0xFFFFDAD6);
const Color kLightOnErrorContainer = Color(0xFF410002);

const Color kLightBackground = Color(0xFFFFF8F9);   // Background agak kemerahan dikit biar "sweet"
const Color kLightOnBackground = Color(0xFF121212);
const Color kLightSurface = Color(0xFFFFFBFF);
const Color kLightOnSurface = Color(0xFF121212);
const Color kLightSurfaceVariant = Color(0xFFF2DDE1);
const Color kLightOnSurfaceVariant = Color(0xFF504346);
const Color kLightOutline = Color(0xFF827377);

/* =========================
   DARK THEME (DESSERT THEME)
   ========================= */
const Color kDarkPrimary = kDessertPinkLight;
const Color kDarkOnPrimary = Color(0xFF4B0025);
const Color kDarkPrimaryContainer = Color(0xFF70003B);
const Color kDarkOnPrimaryContainer = Color(0xFFFFD8E4);

const Color kDarkSecondary = kDelcomYellow;
const Color kDarkOnSecondary = Color(0xFF2A1F00);
const Color kDarkSecondaryContainer = Color(0xFF5A4600);
const Color kDarkOnSecondaryContainer = kDelcomYellowSoft;

const Color kDarkTertiary = Color(0xFFEFB8C8);
const Color kDarkOnTertiary = Color(0xFF492532);

const Color kDarkError = Color(0xFFFFB4AB);
const Color kDarkOnError = Color(0xFF690005);
const Color kDarkErrorContainer = Color(0xFF93000A);
const Color kDarkOnErrorContainer = Color(0xFFFFDAD6);

const Color kDarkBackground = Color(0xFF201A1B);
const Color kDarkOnBackground = Color(0xFFECE0E1);
const Color kDarkSurface = Color(0xFF201A1B);
const Color kDarkOnSurface = Color(0xFFECE0E1);
const Color kDarkSurfaceVariant = Color(0xFF504346);
const Color kDarkOnSurfaceVariant = Color(0xFFD3C2C5);
const Color kDarkOutline = Color(0xFF9C8D90);