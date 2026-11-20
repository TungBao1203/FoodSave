import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/recipe_model.dart';

class IngredientItemWidget extends StatelessWidget {
  final RecipeIngredient ingredient;
  final bool isChecked;
  final VoidCallback onTap;

  const IngredientItemWidget({
    super.key,
    required this.ingredient,
    required this.isChecked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            // Status Icon: Green filled check if available, Orange outline if missing
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isChecked ? AppColors.accentGreen : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isChecked
                      ? AppColors.accentGreen
                      : AppColors.accentOrangeBorder,
                  width: 1.8,
                ),
              ),
              child: isChecked
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 14,
                    )
                  : null,
            ),
            const SizedBox(width: 12),

            // Ingredient name
            Expanded(
              child: Text(
                ingredient.name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isChecked ? AppColors.textPrimary : AppColors.textSecondary,
                  decoration: isChecked ? null : null,
                ),
              ),
            ),

            // Ingredient quantity
            Text(
              ingredient.amount,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
