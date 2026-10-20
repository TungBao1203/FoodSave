import 'package:flutter/material.dart';
import '../core/app_colors.dart';


class PrimaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final style = FilledButton.styleFrom(
      backgroundColor: AppColors.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
    );
    const textStyle = TextStyle(fontSize: 15, fontWeight: FontWeight.w700);

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: icon == null
          ? FilledButton(
        onPressed: onPressed,
        style: style,
        child: Text(label, style: textStyle),
      )
          : FilledButton.icon(
        onPressed: onPressed,
        style: style,
        icon: Icon(icon, size: 20),
        label: Text(label, style: textStyle),
      ),
    );
  }
}


class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textDark,
          backgroundColor: Colors.white,
          side: const BorderSide(color: AppColors.border),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}