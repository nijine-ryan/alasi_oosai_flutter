import 'package:alai_oosai/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

class IconLabelFooter extends StatelessWidget {
  final IconData icon;
  final String label;
  const IconLabelFooter({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.slate500),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.slate500,
          ),
        ),
      ],
    );
  }
}
