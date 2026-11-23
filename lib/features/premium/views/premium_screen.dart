import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../viewmodels/premium_viewmodel.dart';
import '../widgets/plan_selector_widget.dart';
import '../widgets/feature_comparison_table.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  late final PremiumViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = PremiumViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _handleUpgrade() async {
    final success = await _viewModel.upgrade();
    if (!mounted) return;

    if (success) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          icon: const Icon(
            Icons.check_circle_rounded,
            color: AppColors.accentGreen,
            size: 48,
          ),
          title: const Text('Nâng cấp thành công!'),
          content: const Text(
            'Chúc mừng bạn đã mở khóa toàn bộ quyền lợi FoodSave Premium! Nhóm gia đình hiện không còn giới hạn thành viên.',
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context); // Go back
              },
              child: const Text('Bắt đầu trải nghiệm'),
            ),
          ],
        ),
      );
    }
  }

  // Mở BottomSheet giải thích Cam kết an toàn & Quyền lợi khách hàng (Icon cái khiên)
  void _showSecurityBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: AppColors.borderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.shield_rounded,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Cam kết An toàn & Quyền lợi',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTrustItem(
              icon: Icons.lock_outline_rounded,
              title: 'Bảo mật thanh toán 100%',
              description:
                  'Giao dịch được mã hóa và xử lý qua cổng thanh toán bảo mật tiêu chuẩn quốc tế. FoodSave không lưu giữ thông tin thẻ của bạn.',
            ),
            const Divider(height: 20),
            _buildTrustItem(
              icon: Icons.autorenew_rounded,
              title: 'Hủy gia hạn dễ dàng bất kỳ lúc nào',
              description:
                  'Không ràng buộc hợp đồng. Bạn có thể tự do hủy trước kỳ thanh toán tiếp theo chỉ với 1 chạm, hoàn toàn không có phí ẩn.',
            ),
            const Divider(height: 20),
            _buildTrustItem(
              icon: Icons.privacy_tip_outlined,
              title: 'Bảo vệ quyền riêng tư gia đình',
              description:
                  'Danh sách thực phẩm và dữ liệu nhóm chỉ được chia sẻ trong nội bộ gia đình bạn, cam kết không bán cho bên thứ ba.',
            ),
            const Divider(height: 20),
            _buildTrustItem(
              icon: Icons.headset_mic_outlined,
              title: 'Hỗ trợ khách hàng ưu tiên 24/7',
              description:
                  'Mọi thắc mắc của thành viên gói Premium được đội ngũ kỹ thuật hỗ trợ và giải quyết nhanh chóng trong vòng 15 phút.',
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Đã hiểu & Hoàn toàn an tâm',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  static Widget _buildTrustItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F9F4),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Thẻ Hero Card thiết kế nhỏ gọn, tinh tế, hài hòa với toàn app
  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F9F5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryContainer,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Vương miện Premium nhỏ xinh
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight, width: 0.8),
            ),
            child: const Icon(
              Icons.workspace_premium_rounded,
              color: AppColors.accentGold,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),

          // Nội dung ngắn gọn, vừa vặn
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'GÓI GIA ĐÌNH',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      '• Không giới hạn',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                const Text(
                  'Mở khóa trọn vẹn FoodSave',
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Cả nhà cùng quản lý tủ lạnh, không giới hạn thành viên và quét AI.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text('FoodSave Premium'),
            actions: [
              IconButton(
                tooltip: 'Cam kết an toàn & Quyền lợi',
                icon: const Icon(Icons.shield_outlined, size: 22),
                onPressed: () => _showSecurityBottomSheet(context),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Family Hero Card nâng cấp sang trọng
                _buildHeroCard(),
                const SizedBox(height: 20),

                // 2. Bộ chọn chu kỳ thanh toán dọc tối ưu tâm lý học
                PlanSelectorWidget(
                  selectedPlan: _viewModel.selectedPlan,
                  onSelectPlan: _viewModel.selectPlan,
                ),
                const SizedBox(height: 20),

                // 3. Bảng so sánh tính năng Free vs Premium
                const FeatureComparisonTable(),
                const SizedBox(height: 16),

                // 4. Ghi chú bảo mật thanh toán
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.accentOrangeLight.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.accentOrangeBorder.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.verified_user_outlined,
                        size: 16,
                        color: AppColors.accentOrange,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Thanh toán an toàn, minh bạch. Dữ liệu tủ lạnh gia đình luôn được bảo mật 100%.',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: AppColors.textSecondary,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 5. Nút bấm CTA nâng cấp
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _viewModel.isProcessing ? null : _handleUpgrade,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _viewModel.isProcessing
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.2,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.auto_awesome,
                                size: 18,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _viewModel.ctaButtonText,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 10),

                // Subtext
                Center(
                  child: Text(
                    _viewModel.pricingSubtext,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}
