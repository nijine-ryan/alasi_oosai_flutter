import 'package:flutter/material.dart';
import 'package:alai_oosai/features/auth/data/auth_colors.dart';
import 'package:alai_oosai/features/auth/data/auth_service.dart';
import 'package:alai_oosai/features/auth/presentation/widgets/shared/auth_header.dart';
import 'package:alai_oosai/features/auth/presentation/widgets/shared/auth_error_snack_bar.dart';
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
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _onSendOtp() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      AuthErrorSnackBar.show(context, 'Please enter your phone number.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await AuthService.sendLoginOtp(phoneNumber: phone);
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => LoginOtpVerificationScreen(phoneNumber: phone),
        ),
      );
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
                      onSendOtp: _isLoading ? () {} : _onSendOtp,
                      onRegister: _onRegister,
                      isLoading: _isLoading,
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
