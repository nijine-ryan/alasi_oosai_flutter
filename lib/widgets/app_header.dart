// ─── Header ───────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:alai_oosai/core/constants/app_constants.dart';
import 'package:alai_oosai/widgets/notification_button.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white.withAlpha(204), // 80% opacity
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(26),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.volunteer_activism,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Community Trust',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.slate900,
              letterSpacing: -0.3,
            ),
          ),
          const Spacer(),
          NotificationButton(),
        ],
      ),
    );
  }
}
