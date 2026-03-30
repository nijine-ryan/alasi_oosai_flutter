import 'package:flutter/material.dart';
import 'package:alai_oosai/features/auth/data/auth_colors.dart';
import 'package:alai_oosai/features/auth/presentation/widgets/shared/auth_submit_button.dart';
import 'package:alai_oosai/features/auth/presentation/widgets/shared/otp_input_grid.dart';
import 'package:alai_oosai/features/auth/presentation/widgets/shared/otp_resend_row.dart';
import 'package:alai_oosai/features/auth/presentation/widgets/login/login_encrypted_badge.dart';

/// OTP verification card for the login flow.
/// Reuses OtpInputGrid and OtpResendRow from shared widgets.
/// Contains: OTP label, 6-digit grid, Verify button,
///           resend row, encrypted badge, "Contact Security Desk" link.

class LoginOtpCard extends StatelessWidget {
  final VoidCallback onVerify;
  final VoidCallback onResend;
  final VoidCallback onContactSupport;

  const LoginOtpCard({
    super.key,
    required this.onVerify,
    required this.onResend,
    required this.onContactSupport,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AuthColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AuthColors.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            // OTP label
            const Text(
              'ONE-TIME PASSWORD',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AuthColors.primary,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 20),
            // 6-digit OTP grid — reused from shared widgets
            OtpInputGrid(onCompleted: (otp) => debugPrint('Login OTP: $otp')),
            const SizedBox(height: 32),
            // Verify button
            AuthSubmitButton(
              label: 'Verify OTP',
              trailingIcon: Icons.shield_outlined,
              onTap: onVerify,
            ),
            const SizedBox(height: 24),
            // Resend row — reused from shared widgets
            OtpResendRow(onResend: onResend),
            const SizedBox(height: 20),
            // Encrypted session badge
            const LoginEncryptedBadge(),
            const SizedBox(height: 24),
            // Contact security desk
            GestureDetector(
              onTap: onContactSupport,
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 11,
                    color: AuthColors.onSurfaceMuted,
                    height: 1.6,
                  ),
                  children: [
                    TextSpan(text: 'Having trouble? '),
                    TextSpan(
                      text: 'Contact Security Desk',
                      style: TextStyle(
                        color: AuthColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
