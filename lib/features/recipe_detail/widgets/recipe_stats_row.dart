import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class RecipeStatsRow extends StatelessWidget {
  final int cookTimeMinutes;
  final String? difficulty;
  final int servings;

  const RecipeStatsRow({
    super.key,
    required this.cookTimeMinutes,
    this.difficulty,
    required this.servings,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildStatBadge(Icons.access_time_rounded, '$cookTimeMinutes phút'),
        const SizedBox(width: 8),
        _buildStatBadge(Icons.people_outline_rounded, '$servings người'),
      ],
    );
  }

  Widget _buildStatBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: AppColors.textSecondary),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
