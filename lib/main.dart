import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FoodSaveApp());
}

class FoodSaveApp extends StatelessWidget {
  const FoodSaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodSave',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.suggestions,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}

// Alias for compatibility
typedef MyApp = FoodSaveApp;
