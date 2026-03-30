import 'package:flutter/material.dart';
import 'package:alai_oosai/features/auth/data/auth_colors.dart';

class LoginHeadline extends StatelessWidget {
  final String title;
  final String subtitle;

  const LoginHeadline({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final colors = AuthColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w800,
              color: colors.onSurface,
              height: 1.1,
              letterSpacing: -1.0,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 15,
              color: colors.onSurfaceVariant,
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
