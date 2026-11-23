import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class InviteMethodCard extends StatelessWidget {
  final bool isLimitReached;
  final VoidCallback onTapQR;
  final VoidCallback onTapPhone;

  const InviteMethodCard({
    super.key,
    required this.isLimitReached,
    required this.onTapQR,
    required this.onTapPhone,
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
              'Mời vào Nhà mình',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            if (isLimitReached)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.accentOrangeLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Đã đạt hạn mức Free',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accentOrange,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),

        // 2 nút hành động lớn: Quét QR & Mời qua SĐT
        Row(
          children: [
            Expanded(
              child: _buildActionTile(
                icon: Icons.qr_code_2_rounded,
                title: 'Quét mã QR',
                subtitle: 'Quét vào nhóm ngay',
                onTap: onTapQR,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionTile(
                icon: Icons.phone_android_rounded,
                title: 'Mời qua SĐT',
                subtitle: 'Nhập số người thân',
                onTap: onTapPhone,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Ghi chú bảo mật & chia sẻ
        const Row(
          children: [
            Icon(
              Icons.verified_user_outlined,
              size: 14,
              color: AppColors.textMuted,
            ),
            SizedBox(width: 6),
            Expanded(
              child: Text(
                'Chỉ thành viên trong nhóm mới xem được thực phẩm chung.',
                style: TextStyle(
                  fontSize: 11.5,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderLight, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary, size: 22),
            ),
            const SizedBox(height: 10),
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
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11.5,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
