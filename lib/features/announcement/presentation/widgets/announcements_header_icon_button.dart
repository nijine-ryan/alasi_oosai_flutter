import 'package:flutter/material.dart';
import 'package:alai_oosai/core/constants/app_constants.dart';

class AnnouncementsHeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const AnnouncementsHeaderIconButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: Icon(icon, color: AppColors.slate700, size: 24),
      ),
    );
  }
}
