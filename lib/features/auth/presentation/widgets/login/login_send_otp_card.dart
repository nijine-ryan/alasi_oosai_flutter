import 'package:flutter/material.dart';
import 'package:alai_oosai/features/auth/data/auth_colors.dart';
import 'package:alai_oosai/features/auth/presentation/widgets/shared/auth_submit_button.dart';
import 'package:alai_oosai/features/auth/presentation/widgets/login/login_phone_input.dart';

class LoginSendOtpCard extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSendOtp;
  final VoidCallback onRegister;
  final bool isLoading;

  const LoginSendOtpCard({
    super.key,
    required this.controller,
    required this.onSendOtp,
    required this.onRegister,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AuthColors.of(context);
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LoginPhoneInput(controller: controller),
            const SizedBox(height: 28),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : AuthSubmitButton(
                    label: 'Send OTP',
                    trailingIcon: Icons.shield_outlined,
                    onTap: onSendOtp,
                  ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: onRegister,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'New user? ',
                        style: TextStyle(
                          fontSize: 13,
                          color: colors.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 13,
                          color: AuthColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'By continuing, you agree to our Security Protocols and Privacy Charter.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: colors.onSurfaceMuted,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
