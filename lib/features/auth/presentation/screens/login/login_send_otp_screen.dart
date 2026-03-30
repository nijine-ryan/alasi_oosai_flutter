import 'package:flutter/material.dart';
import 'package:alai_oosai/features/auth/data/auth_colors.dart';
import 'package:alai_oosai/features/auth/presentation/widgets/shared/auth_header.dart';
import 'package:alai_oosai/features/auth/presentation/widgets/login/login_headline.dart';
import 'package:alai_oosai/features/auth/presentation/widgets/login/login_send_otp_card.dart';
import 'package:alai_oosai/features/auth/presentation/screens/login/login_otp_verification_screen.dart';
import 'package:alai_oosai/features/auth/presentation/screens/register/family_registration_screen.dart';

class LoginSendOtpScreen extends StatefulWidget {
  const LoginSendOtpScreen({super.key});

  @override
  State<LoginSendOtpScreen> createState() => LoginSendOtpScreenState();
}

class LoginSendOtpScreenState extends State<LoginSendOtpScreen> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onSendOtp() {
    if (_phoneController.text.trim().isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LoginOtpVerificationScreen(
          maskedPhone: _phoneController.text.trim(),
        ),
      ),
    );
  }

  void _onRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FamilyRegistrationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AuthColors.of(context);
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            const AuthHeader(title: 'Trusted Sentinel', showBack: false),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    const LoginHeadline(
                      title: 'Secure\nAccess.',
                      subtitle:
                          'Enter your phone number to receive a secure one-time passcode.',
                    ),
                    const SizedBox(height: 32),
                    LoginSendOtpCard(
                      controller: _phoneController,
                      onSendOtp: _onSendOtp,
                      onRegister: _onRegister,
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
