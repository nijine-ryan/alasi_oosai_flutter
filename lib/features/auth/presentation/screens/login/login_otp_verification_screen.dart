import 'package:flutter/material.dart';
import 'package:alai_oosai/features/auth/data/auth_colors.dart';
import 'package:alai_oosai/features/auth/presentation/widgets/shared/auth_header.dart';
import 'package:alai_oosai/features/auth/presentation/widgets/login/login_headline.dart';
import 'package:alai_oosai/features/auth/presentation/widgets/login/login_otp_card.dart';
import 'package:alai_oosai/main.dart';

class LoginOtpVerificationScreen extends StatelessWidget {
  final String maskedPhone;

  const LoginOtpVerificationScreen({super.key, required this.maskedPhone});

  @override
  Widget build(BuildContext context) {
    final colors = AuthColors.of(context);
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            AuthHeader(
              title: 'Trusted Sentinel',
              trailingWidget: const Text(
                'TS',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: AuthColors.primary,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    const LoginHeadline(
                      title: 'Verify\nIdentity.',
                      subtitle:
                          "We've sent a 6-digit code to your registered device.",
                    ),
                    const SizedBox(height: 32),
                    LoginOtpCard(
                      onVerify: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MainNavigationPage(),
                          ),
                          (route) => false,
                        );
                      },
                      onResend: () {},
                      onContactSupport: () {},
                    ),
                    const SizedBox(height: 40),
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
