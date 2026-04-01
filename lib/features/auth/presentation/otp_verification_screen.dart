import 'package:flutter/material.dart';
import 'package:alai_oosai/features/auth/data/auth_colors.dart';
import 'package:alai_oosai/features/auth/presentation/widgets/shared/auth_header.dart';
import 'package:alai_oosai/features/auth/presentation/widgets/shared/auth_submit_button.dart';
import 'package:alai_oosai/features/auth/presentation/widgets/shared/otp_input_grid.dart';
import 'package:alai_oosai/features/auth/presentation/widgets/shared/otp_resend_row.dart';
import 'package:alai_oosai/features/auth/presentation/widgets/shared/otp_encryption_badge.dart';
import 'package:alai_oosai/main.dart';
import 'package:alai_oosai/core/constants/env_config.dart';
import 'package:alai_oosai/features/auth/presentation/widgets/shared/auth_error_snack_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String maskedPhone;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
    this.maskedPhone = '•8829',
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  bool _isLoading = false;

  Future<void> _verifyOtp(String otp) async {
    setState(() => _isLoading = true);
    final url = Uri.parse('${EnvConfig.baseUrl}/auth/verify-otp');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'phone_number': widget.phoneNumber,
          'otp': int.tryParse(otp),
        }),
      );
      final body = json.decode(response.body);
      if (!mounted) return;
      if (response.statusCode >= 200 &&
          response.statusCode < 300 &&
          body['success'] == true) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MainNavigationPage()),
          (route) => false,
        );
      } else {
        AuthErrorSnackBar.show(
          context,
          body['message']?.toString() ?? 'OTP verification failed',
        );
      }
    } catch (e) {
      if (!mounted) return;
      AuthErrorSnackBar.show(context, 'Network error. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AuthColors.of(context);
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AuthHeader(
              title: 'Trusted Sentinel',
              trailingWidget: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AuthColors.primary.withAlpha(26),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'STEP 2 OF 2',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AuthColors.primary,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Verification\nRequired',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: colors.onSurface,
                        letterSpacing: -0.8,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 14),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 14,
                          color: colors.onSurfaceVariant,
                          height: 1.55,
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          const TextSpan(
                            text:
                                "We've sent a 6-digit secure code to your registered mobile number ending in ",
                          ),
                          TextSpan(
                            text: widget.maskedPhone,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: colors.onSurface,
                            ),
                          ),
                          const TextSpan(text: '.'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    OtpInputGrid(onCompleted: _verifyOtp),
                    const SizedBox(height: 36),
                    AuthSubmitButton(
                      label: _isLoading ? 'Verifying...' : 'Verify OTP',
                      onTap: _isLoading
                          ? () {}
                          : () {}, // Disabled when loading
                    ),
                    const SizedBox(height: 28),
                    OtpResendRow(onResend: () {}),
                    const SizedBox(height: 24),
                    const OtpEncryptionBadge(),
                    const SizedBox(height: 40),
                    Center(
                      child: Text(
                        'IDENTITY PROTECTION • 2024 TRUSTED SENTINEL INC.',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: colors.outlineVariant,
                          letterSpacing: 1.2,
                        ),
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
