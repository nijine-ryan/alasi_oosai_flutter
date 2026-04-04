import 'package:flutter/material.dart';
import 'package:alai_oosai/features/auth/data/auth_colors.dart';
import 'package:alai_oosai/features/auth/data/auth_service.dart';
import 'package:alai_oosai/features/auth/presentation/widgets/shared/auth_submit_button.dart';
import 'package:alai_oosai/features/auth/presentation/widgets/shared/otp_input_grid.dart';
import 'package:alai_oosai/features/auth/presentation/widgets/shared/otp_resend_row.dart';
import 'package:alai_oosai/features/auth/presentation/widgets/login/login_encrypted_badge.dart';
import 'package:alai_oosai/features/auth/presentation/widgets/shared/auth_error_snack_bar.dart';
import 'package:alai_oosai/services/notification_service.dart';
import 'package:alai_oosai/services/socket_service.dart';

/// OTP verification card for the login flow.
/// Collects OTP, calls /auth/verify-otp, and invokes [onVerifySuccess] on success.

class LoginOtpCard extends StatefulWidget {
  final String phoneNumber;
  final VoidCallback onVerifySuccess;
  final VoidCallback onResend;
  final VoidCallback onContactSupport;

  const LoginOtpCard({
    super.key,
    required this.phoneNumber,
    required this.onVerifySuccess,
    required this.onResend,
    required this.onContactSupport,
  });

  @override
  State<LoginOtpCard> createState() => _LoginOtpCardState();
}

class _LoginOtpCardState extends State<LoginOtpCard> {
  String _otp = '';
  bool _isLoading = false;

  Future<void> _onVerify() async {
    if (_otp.length != 6) {
      AuthErrorSnackBar.show(context, 'Please enter the 6-digit OTP.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await AuthService.verifyLoginOtp(
        phoneNumber: widget.phoneNumber,
        otp: int.parse(_otp),
      );
      // Post-login: register device token, subscribe to village topic, connect socket.
      // Fire-and-forget — do not await so navigation is not delayed.
      NotificationService.registerDeviceToken();
      if (AuthService.villageId != null) {
        NotificationService.subscribeToVillage(AuthService.villageId!);
        NotificationService.subscribeToReportTopic(AuthService.villageId!);
      }
      SocketService.connect();
      if (!mounted) return;
      widget.onVerifySuccess();
    } catch (e) {
      if (!mounted) return;
      AuthErrorSnackBar.show(
        context,
        e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
            // 6-digit OTP grid
            OtpInputGrid(onCompleted: (otp) => setState(() => _otp = otp)),
            const SizedBox(height: 32),
            // Verify button
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : AuthSubmitButton(
                    label: 'Verify OTP',
                    trailingIcon: Icons.shield_outlined,
                    onTap: _onVerify,
                  ),
            const SizedBox(height: 24),
            // Resend row
            OtpResendRow(onResend: widget.onResend),
            const SizedBox(height: 20),
            // Encrypted session badge
            const LoginEncryptedBadge(),
            const SizedBox(height: 24),
            // Contact security desk
            GestureDetector(
              onTap: widget.onContactSupport,
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
