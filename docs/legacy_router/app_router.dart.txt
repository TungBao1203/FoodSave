import 'package:go_router/go_router.dart';

import '../../features/add_food/presentation/add_food_screen.dart';
import '../../features/ai_recipes/presentation/ai_recipes_screen.dart';
import '../../features/ai_recipes/presentation/recipe_detail_screen.dart';
import '../../features/ai_result/presentation/ai_result_screen.dart';
import '../../features/ai_scan/presentation/ai_scan_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/phone_screen.dart';
import '../../features/family/presentation/family_screen.dart';
import '../../features/fridge/presentation/fridge_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/premium/presentation/premium_screen.dart';
import '../../features/welcome/presentation/welcome_screen.dart';
import '../../shared/widgets/main_shell.dart';
import 'routes.dart';

final appRouter = GoRouter(
  initialLocation: Routes.welcome,
  routes: [
    // --- Onboarding / auth ---
    GoRoute(path: Routes.welcome, builder: (_, __) => const WelcomeScreen()),
    GoRoute(path: Routes.phone, builder: (_, __) => const PhoneScreen()),
    GoRoute(path: Routes.login, builder: (_, __) => const LoginScreen()),

    // --- 4 tab chính (giữ trạng thái từng tab) ---
    StatefulShellRoute.indexedStack(
      builder: (_, __, shell) => MainShell(navigationShell: shell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(path: Routes.home, builder: (_, __) => const HomeScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: Routes.fridge, builder: (_, __) => const FridgeScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
              path: Routes.aiRecipes,
              builder: (_, __) => const AiRecipesScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: Routes.family, builder: (_, __) => const FamilyScreen()),
        ]),
      ],
    ),

    // --- Màn push phía trên thanh tab ---
    GoRoute(path: Routes.addFood, builder: (_, __) => const AddFoodScreen()),
    GoRoute(path: Routes.aiScan, builder: (_, __) => const AiScanScreen()),
    GoRoute(path: Routes.aiResult, builder: (_, __) => const AiResultScreen()),
    GoRoute(path: Routes.premium, builder: (_, __) => const PremiumScreen()),
    GoRoute(
      path: Routes.recipeDetail,
      builder: (_, state) =>
          RecipeDetailScreen(recipeId: state.pathParameters['id'] ?? ''),
    ),
  ],
);