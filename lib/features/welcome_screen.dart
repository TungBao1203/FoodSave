import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/feature_chip.dart';
import '../widgets/page_dots.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20, 12, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTopBar(),
                    SizedBox(height: 16),
                    _HeroImage(),
                    SizedBox(height: 14),
                    FeatureChip(
                        text: 'Nhập nhanh · Nhắc hạn · Tiết kiệm cùng nhau'),
                    SizedBox(height: 14),
                    Text(
                      'Tủ lạnh thông minh\n– Gia đình kết nối –\nTiết kiệm mỗi ngày.',
                      style: TextStyle(
                        fontSize: 26,
                        height: 1.25,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'FoodSave giúp cả nhà dùng chung, nhập nhanh bằng OCR '
                          'hóa đơn, mã vạch, chụp ảnh hoặc tay, và nhắc hạn trước '
                          'khi quên để giảm lãng phí.',
                      style: TextStyle(
                        fontSize: 13.5,
                        height: 1.5,
                        color: AppColors.textMuted,
                      ),
                    ),
                    SizedBox(height: 12),
                    Center(child: PageDots(count: 3, active: 0)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PrimaryButton(
                    label: 'Bắt đầu với số điện thoại',
                    icon: Icons.smartphone_rounded,
                    // TODO: sau này chuyển sang màn nhập số điện thoại
                    onPressed: () => _toast(context, 'Bắt đầu với số điện thoại'),
                  ),
                  const SizedBox(height: 10),
                  SecondaryButton(
                    label: 'Đăng nhập',
                    // TODO: sau này chuyển sang màn đăng nhập
                    onPressed: () => _toast(context, 'Đăng nhập'),
                  ),
                  const SizedBox(height: 10),
                  const Text.rich(
                    TextSpan(
                      style:
                      TextStyle(fontSize: 10.5, color: AppColors.textMuted),
                      children: [
                        TextSpan(text: 'Bằng việc tiếp tục, bạn đồng ý với '),
                        TextSpan(
                          text: 'Điều khoản & Quyền riêng tư',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  const _HeroImage();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: AspectRatio(
        aspectRatio: 1.15,
        // Khi có ảnh: đặt vào assets/images/welcome_family.jpg và khai báo
        // assets trong pubspec.yaml. Chưa có ảnh thì hiện khối màu bên dưới.
        child: Image.asset(
          'assets/images/welcome_family.jpg',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: AppColors.primarySoft,
            alignment: Alignment.center,
            child: const Icon(Icons.family_restroom_rounded,
                size: 64, color: AppColors.primary),
          ),
        ),
      ),
    );
  }
}