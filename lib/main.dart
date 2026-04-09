// lib/main.dart

import 'package:flutter/material.dart';
import 'app.dart';

void main() {
  // Memastikan binding framework Flutter sudah siap sebelum menjalankan app
  WidgetsFlutterBinding.ensureInitialized();

  // Menjalankan aplikasi utama yang sekarang sudah mendukung Plants & Desserts
  runApp(const DelcomApp());
}