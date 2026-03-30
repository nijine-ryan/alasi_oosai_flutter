import 'package:flutter/material.dart';
import 'package:alai_oosai/features/auth/data/auth_colors.dart';

class MemberListHeader extends StatelessWidget {
  const MemberListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AuthColors.of(context);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: AuthColors.primary.withAlpha(26),
            borderRadius: BorderRadius.circular(999),
          ),
          child: const Text(
            'Step 02 • Verification',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AuthColors.primary,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Circle Enrollment',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: colors.onSurface,
            letterSpacing: -0.5,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Select a family member to add to your vault.\nGreyed members are already registered.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: colors.onSurfaceVariant,
            height: 1.55,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
