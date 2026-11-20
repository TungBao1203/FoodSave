import 'package:flutter/material.dart';
import '../core/app_colors.dart';


class PageDots extends StatelessWidget {
  final int count;
  final int active;
  const PageDots({super.key, required this.count, required this.active});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        final on = i == active;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: on ? 18 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: on ? AppColors.primary : AppColors.border,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}