import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/scanner/views/scanner_screen.dart';

void main() {
  runApp(const ScannerPreviewApp());
}

class ScannerPreviewApp extends StatelessWidget {
  const ScannerPreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodSave - Scanner Preview',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const ScannerScreen(),
    );
  }
}
