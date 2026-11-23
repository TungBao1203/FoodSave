import 'package:flutter/material.dart';
import '../../data/models/recipe_model.dart';
import '../../features/suggestions/views/suggestions_screen.dart';
import '../../features/recipe_detail/views/recipe_detail_screen.dart';
import '../../features/family/views/family_screen.dart';
import '../../features/premium/views/premium_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String suggestions = '/suggestions';
  static const String recipeDetail = '/recipe-detail';
  static const String family = '/family';
  static const String premium = '/premium';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case suggestions:
        return MaterialPageRoute(
          builder: (_) => const SuggestionsScreen(),
          settings: settings,
        );
      case recipeDetail:
        if (settings.arguments is RecipeModel) {
          return MaterialPageRoute(
            builder: (_) => RecipeDetailScreen(
              initialRecipe: settings.arguments as RecipeModel,
            ),
            settings: settings,
          );
        }
        final recipeId = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => RecipeDetailScreen(recipeId: recipeId ?? 'thit_sot_ca_chua'),
          settings: settings,
        );
      case family:
        return MaterialPageRoute(
          builder: (_) => const FamilyScreen(),
          settings: settings,
        );
      case premium:
        return MaterialPageRoute(
          builder: (_) => const PremiumScreen(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const SuggestionsScreen(),
          settings: settings,
        );
    }
  }
}
