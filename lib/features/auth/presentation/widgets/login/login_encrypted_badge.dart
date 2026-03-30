import 'package:flutter/material.dart';
import 'package:alai_oosai/features/auth/data/auth_colors.dart';

class LoginEncryptedBadge extends StatelessWidget {
  const LoginEncryptedBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AuthColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified_user_outlined,
            color: Color(0xFF34D399),
            size: 16,
          ),
          SizedBox(width: 8),
          Text(
            'ENCRYPTED SESSION',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AuthColors.primary,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
