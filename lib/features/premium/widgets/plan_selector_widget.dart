import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../viewmodels/premium_viewmodel.dart';

class PlanSelectorWidget extends StatelessWidget {
  final SubscriptionPlan selectedPlan;
  final ValueChanged<SubscriptionPlan> onSelectPlan;

  const PlanSelectorWidget({
    super.key,
    required this.selectedPlan,
    required this.onSelectPlan,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Chọn chu kỳ thanh toán',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // Monthly Card
            Expanded(
              child: _buildPlanCard(
                plan: SubscriptionPlan.monthly,
                title: 'Hàng tháng',
                price: '59.000đ / tháng',
                isSelected: selectedPlan == SubscriptionPlan.monthly,
              ),
            ),
            const SizedBox(width: 12),

            // Yearly Card
            Expanded(
              child: _buildPlanCard(
                plan: SubscriptionPlan.yearly,
                title: 'Hàng năm',
                badgeText: 'Tiết kiệm 34%',
                price: '29.000đ / tháng',
                isSelected: selectedPlan == SubscriptionPlan.yearly,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlanCard({
    required SubscriptionPlan plan,
    required String title,
    String? badgeText,
    required String price,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () => onSelectPlan(plan),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryContainer.withValues(alpha: 0.4)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderLight,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (badgeText != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.accentOrangeLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      badgeText,
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: AppColors.accentOrange,
                      ),
                    ),
                  )
                else if (isSelected)
                  const Icon(
                    Icons.check_circle_rounded,
                    size: 18,
                    color: AppColors.primary,
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    price,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
                if (badgeText != null && isSelected)
                  const Icon(
                    Icons.check_circle_rounded,
                    size: 18,
                    color: AppColors.primary,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
