import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/recipe_model.dart';

class RecipeTileCard extends StatelessWidget {
  final RecipeModel recipe;
  final VoidCallback onTap;

  const RecipeTileCard({
    super.key,
    required this.recipe,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final missingCount =
        recipe.totalIngredientsCount - recipe.availableIngredientsCount;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderLight, width: 1),
        ),
        child: Row(
          children: [
            // Ảnh món ăn vuông vắn, bo góc 12
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                recipe.imageUrl,
                width: 76,
                height: 76,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 76,
                  height: 76,
                  color: AppColors.primaryContainer,
                  child: const Icon(Icons.restaurant, color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Thông tin món ăn tinh gọn
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 1. Tên món ăn
                  Text(
                    recipe.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // 2. Thời gian nấu
                  Row(
                    children: [
                      const Icon(
                        Icons.schedule_rounded,
                        size: 13,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${recipe.cookTimeMinutes} phút',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // 3. Một huy hiệu trạng thái duy nhất: Đủ đồ hoặc Cần mua thêm
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: recipe.hasAllIngredients
                          ? AppColors.accentGreenLight
                          : AppColors.accentOrangeLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          recipe.hasAllIngredients
                              ? Icons.check_circle_rounded
                              : Icons.add_shopping_cart_rounded,
                          size: 12,
                          color: recipe.hasAllIngredients
                              ? AppColors.accentGreen
                              : AppColors.accentOrange,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          recipe.hasAllIngredients
                              ? 'Đủ nguyên liệu'
                              : 'Thiếu $missingCount nguyên liệu',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: recipe.hasAllIngredients
                                ? AppColors.accentGreen
                                : AppColors.accentOrange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Mũi tên chỉ hướng xem chi tiết
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textMuted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
