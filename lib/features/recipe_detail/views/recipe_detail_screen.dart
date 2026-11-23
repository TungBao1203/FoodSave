import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/recipe_model.dart';
import '../../../shared/widgets/app_bottom_nav_bar.dart';
import '../viewmodels/recipe_detail_viewmodel.dart';
import '../widgets/ingredient_item_widget.dart';
import '../widgets/cooking_step_widget.dart';
import '../widgets/recipe_stats_row.dart';

class RecipeDetailScreen extends StatefulWidget {
  final String? recipeId;
  final RecipeModel? initialRecipe;

  const RecipeDetailScreen({
    super.key,
    this.recipeId,
    this.initialRecipe,
  });

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late final RecipeDetailViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = RecipeDetailViewModel();
    if (widget.initialRecipe != null) {
      _viewModel.setRecipe(widget.initialRecipe!);
    } else if (widget.recipeId != null) {
      _viewModel.loadRecipe(widget.recipeId!);
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, _) {
        final recipe = _viewModel.recipe;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  recipe?.isBookmarked == true
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: recipe?.isBookmarked == true
                      ? AppColors.primary
                      : AppColors.textPrimary,
                ),
                onPressed: _viewModel.toggleBookmark,
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: _viewModel.isLoading || recipe == null
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Recipe Hero Image (Sạch sẽ, không chữ/ngữ cảnh che ảnh)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          recipe.imageUrl,
                          height: 220,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            height: 220,
                            color: AppColors.primaryContainer,
                            child: const Center(
                              child: Icon(
                                Icons.restaurant_menu_rounded,
                                size: 54,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Recipe Title
                      Text(
                        recipe.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Recipe Description
                      Text(
                        recipe.description,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Stats Row (Thời gian nấu & Khẩu phần, đã bỏ độ khó)
                      RecipeStatsRow(
                        cookTimeMinutes: recipe.cookTimeMinutes,
                        servings: recipe.servings,
                      ),
                      const SizedBox(height: 20),

                      // Ingredients Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.borderLight,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Nguyên liệu',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  'Đang có ${recipe.availableIngredientsCount}/${recipe.totalIngredientsCount}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            const Row(
                              children: [
                                Icon(
                                  Icons.people_alt_outlined,
                                  size: 14,
                                  color: AppColors.textMuted,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Nguồn: Tủ lạnh chung gia đình',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Divider(),
                            const SizedBox(height: 8),

                            // List of ingredients
                            ...List.generate(recipe.ingredients.length, (index) {
                              final ingredient = recipe.ingredients[index];
                              final isChecked = _viewModel.checkedIngredientIndices
                                  .contains(index);

                              return IngredientItemWidget(
                                ingredient: ingredient,
                                isChecked: isChecked,
                                onTap: () => _viewModel.toggleIngredient(index),
                              );
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Add to Weekly Meal Plan (Premium)
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.premium);
                        },
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.primaryContainer,
                              width: 1,
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 18,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Thêm vào kế hoạch tuần • Premium',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 18,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Steps section
                      Text(
                        '${recipe.steps.length} bước nấu',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // List of steps
                      ...List.generate(recipe.steps.length, (index) {
                        return CookingStepWidget(
                          stepNumber: index + 1,
                          description: recipe.steps[index],
                        );
                      }),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
          bottomNavigationBar: AppBottomNavBar(
            currentIndex: 2, // Active on Món AI
            onTap: (index) {
              if (index == 2) {
                Navigator.pop(context);
              } else if (index == 3) {
                Navigator.pushReplacementNamed(context, AppRoutes.family);
              }
            },
          ),
        );
      },
    );
  }
}
