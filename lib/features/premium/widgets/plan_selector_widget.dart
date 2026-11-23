import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../viewmodels/premium_viewmodel.dart';

/// Bộ chọn gói chu kỳ thanh toán tối ưu tâm lý học chuyển đổi (CRO):
/// - Thẻ dạng danh sách dọc rộng rãi, dễ đọc
/// - Gói 1 Năm (Yearly) nổi bật với huy hiệu "TIẾT KIỆM 50% • KHUYÊN DÙNG"
/// - So sánh trực quan: Chỉ ~1.000đ/ngày
/// - Radio button tích hợp rõ nét
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Chọn gói thanh toán',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Dành cho cả gia đình',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // 1. Thẻ Gói 1 Năm (Khuyên dùng - Best Value)
        _buildVerticalPlanCard(
          plan: SubscriptionPlan.yearly,
          title: 'Gói 1 Năm',
          highlightBadge: 'TIẾT KIỆM 50% • PHỔ BIẾN NHẤT',
          priceMonthlyEquivalent: '29.000đ',
          periodUnit: '/ tháng',
          totalBilledText: 'Thanh toán 348.000đ / năm (~950đ / ngày)',
          noteText: 'Rẻ hơn cả 1 viên kẹo mỗi ngày để bảo vệ tủ lạnh',
          isSelected: selectedPlan == SubscriptionPlan.yearly,
          isRecommended: true,
        ),
        const SizedBox(height: 12),

        // 2. Thẻ Gói 1 Tháng (Linh hoạt)
        _buildVerticalPlanCard(
          plan: SubscriptionPlan.monthly,
          title: 'Gói 1 Tháng',
          highlightBadge: null,
          priceMonthlyEquivalent: '59.000đ',
          periodUnit: '/ tháng',
          totalBilledText: 'Thanh toán 59.000đ hàng tháng',
          noteText: 'Linh hoạt gia hạn theo từng tháng, hủy bất cứ lúc nào',
          isSelected: selectedPlan == SubscriptionPlan.monthly,
          isRecommended: false,
        ),
      ],
    );
  }

  Widget _buildVerticalPlanCard({
    required SubscriptionPlan plan,
    required String title,
    String? highlightBadge,
    required String priceMonthlyEquivalent,
    required String periodUnit,
    required String totalBilledText,
    required String noteText,
    required bool isSelected,
    required bool isRecommended,
  }) {
    return InkWell(
      onTap: () => onSelectPlan(plan),
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF3F9F4) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.borderLight,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.12),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            else
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Khoảng trống nếu có badge phía trên
                    if (highlightBadge != null) const SizedBox(height: 6),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Radio icon tùy biến
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textMuted,
                              width: isSelected ? 6.5 : 1.5,
                            ),
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Tên gói & Ghi chú nhỏ
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? AppColors.textPrimary
                                      : AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                totalBilledText,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Giá quy đổi theo tháng
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: priceMonthlyEquivalent,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                  TextSpan(
                                    text: periodUnit,
                                    style: const TextStyle(
                                      fontSize: 11.5,
                                      color: AppColors.textMuted,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                    // Ghi chú lợi ích
                    Padding(
                      padding: const EdgeInsets.only(left: 34),
                      child: Text(
                        noteText,
                        style: TextStyle(
                          fontSize: 11,
                          color: isSelected ? AppColors.primary : AppColors.textMuted,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Ruy băng Badge nổi bật ở góc trên phải của thẻ Gói 1 Năm
              if (highlightBadge != null)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: const BoxDecoration(
                      color: AppColors.accentOrange,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                      ),
                    ),
                    child: Text(
                      highlightBadge,
                      style: const TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
