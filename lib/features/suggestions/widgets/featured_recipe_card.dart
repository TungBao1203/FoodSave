import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/recipe_model.dart';

class FeaturedRecipeCard extends StatelessWidget {
  final RecipeModel recipe;
  final String? activeFilter;
  final VoidCallback onTap;

  const FeaturedRecipeCard({
    super.key,
    required this.recipe,
    this.activeFilter,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 190,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. Ảnh món ăn tràn viền
              Image.network(
                recipe.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppColors.primaryContainer,
                  child: const Center(
                    child: Icon(Icons.restaurant, size: 48, color: AppColors.primary),
                  ),
                ),
              ),

              // 2. Gradient Overlay mịn màng giúp chữ bên dưới luôn rõ nét
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.85),
                    ],
                    stops: const [0.0, 0.45, 1.0],
                  ),
                ),
              ),

              // 3. Khối thông tin món ăn ở đáy thẻ (tinh gọn, không nút bấm, không huy hiệu thừa)
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      recipe.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            blurRadius: 4,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          size: 14,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${recipe.cookTimeMinutes} phút',
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '•',
                          style: TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          recipe.hasAllIngredients
                              ? 'Đủ ${recipe.totalIngredientsCount} nguyên liệu'
                              : 'Thiếu ${recipe.missingIngredientsCount} vị',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: recipe.hasAllIngredients
                                ? Colors.white
                                : const Color(0xFFFFCC80),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
