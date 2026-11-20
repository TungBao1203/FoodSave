import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AppLeafLogo extends StatelessWidget {
  final double size;

  const AppLeafLogo({super.key, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(size * 0.32),
      ),
      child: Center(
        child: Icon(
          Icons.eco_rounded,
          color: Colors.white,
          size: size * 0.58,
        ),
      ),
    );
  }
}
