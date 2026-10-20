import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'features/welcome_screen.dart';

class FoodSaveApp extends StatelessWidget {
  const FoodSaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodSave',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const WelcomeScreen(),
    );
  }
}