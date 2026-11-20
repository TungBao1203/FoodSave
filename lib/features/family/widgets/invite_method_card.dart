import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class InviteMethodCard extends StatelessWidget {
  final bool isLimitReached;
  final ValueChanged<String> onSelectMethod;

  const InviteMethodCard({
    super.key,
    required this.isLimitReached,
    required this.onSelectMethod,
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
              const Text(
                'Đã đạt giới hạn',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),

        // 3 buttons: QR, Link, Code
        Row(
          children: [
            Expanded(
              child: _buildActionTile(
                icon: Icons.qr_code_2_rounded,
                title: 'Mã QR',
                subtitle: isLimitReached ? 'Khóa do giới hạn' : 'Quét trực tiếp',
                onTap: () => onSelectMethod('QR'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildActionTile(
                icon: Icons.link_rounded,
                title: 'Link',
                subtitle: isLimitReached ? 'Khóa do giới hạn' : 'Gửi qua tin nhắn',
                onTap: () => onSelectMethod('Link'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildActionTile(
                icon: Icons.key_rounded,
                title: 'Mã Code',
                subtitle: isLimitReached ? 'Khóa do giới hạn' : 'Nhập 6 số',
                onTap: () => onSelectMethod('Code'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Security hint
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
                'Lời mời hết hạn sau 24 giờ • Chủ hộ có thể thu hồi bất kỳ lúc nào.',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textMuted,
                  height: 1.3,
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
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderLight, width: 1),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 24,
              color: isLimitReached ? AppColors.textMuted : AppColors.primary,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isLimitReached
                    ? AppColors.textSecondary
                    : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
