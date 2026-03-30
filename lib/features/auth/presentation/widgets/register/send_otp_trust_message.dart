import 'package:flutter/material.dart';
import 'package:alai_oosai/features/auth/data/auth_colors.dart';

class SendOtpTrustMessage extends StatelessWidget {
  const SendOtpTrustMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AuthColors.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.outlineVariant.withAlpha(80)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: AuthColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'A one-time password (OTP) will be sent to this number. Standard messaging and data rates may apply.',
              style: TextStyle(
                fontSize: 12,
                color: colors.onSurfaceVariant,
                height: 1.55,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
