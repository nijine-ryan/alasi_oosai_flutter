import 'package:flutter/material.dart';
import 'package:alai_oosai/features/auth/data/auth_colors.dart';

class SendOtpFooterBadge extends StatelessWidget {
  const SendOtpFooterBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AuthColors.of(context);
    return Opacity(
      opacity: 0.4,
      child: Column(
        children: [
          Icon(Icons.verified_user_outlined, color: colors.onSurface, size: 28),
          const SizedBox(height: 10),
          Text(
            'SECURE AUTHENTICATION LAYER',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: colors.onSurface,
              letterSpacing: 3.0,
            ),
          ),
        ],
      ),
    );
  }
}
