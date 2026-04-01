import 'package:flutter/material.dart';
import 'package:alai_oosai/features/auth/data/auth_colors.dart';
import 'package:alai_oosai/features/auth/data/family_member_model.dart';
import 'package:alai_oosai/features/auth/data/auth_service.dart';
import 'package:alai_oosai/features/auth/presentation/widgets/shared/auth_header.dart';
import 'package:alai_oosai/features/auth/presentation/widgets/shared/auth_submit_button.dart';
import 'package:alai_oosai/features/auth/presentation/widgets/register/send_otp_selected_member_card.dart';
import 'package:alai_oosai/features/auth/presentation/widgets/register/send_otp_phone_input.dart';
import 'package:alai_oosai/features/auth/presentation/widgets/register/send_otp_trust_message.dart';
import 'package:alai_oosai/features/auth/presentation/widgets/register/send_otp_footer_badge.dart';
import 'package:alai_oosai/features/auth/presentation/otp_verification_screen.dart';
import 'package:alai_oosai/features/auth/presentation/widgets/shared/auth_error_snack_bar.dart';

class RegisterSendOtpScreen extends StatefulWidget {
  final List<FamilyMemberModel> selectedMembers;
  final String familyCardNumber;
  final String villageId;
  final String userId;

  const RegisterSendOtpScreen({
    super.key,
    required this.selectedMembers,
    required this.familyCardNumber,
    required this.villageId,
    required this.userId,
  });

  @override
  State<RegisterSendOtpScreen> createState() => RegisterSendOtpScreenState();
}

class RegisterSendOtpScreenState extends State<RegisterSendOtpScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  void _onSendOtp() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      AuthErrorSnackBar.show(context, 'Please enter a phone number.');
      return;
    }
    setState(() => _isLoading = true);
    try {
      await AuthService.sendOtp(
        phoneNumber: phone,
        familyCard: widget.familyCardNumber,
        villageId: widget.villageId,
        userId: widget.userId,
      );
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpVerificationScreen(phoneNumber: phone),
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

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  FamilyMemberModel? get _primaryMember =>
      widget.selectedMembers.isNotEmpty ? widget.selectedMembers.first : null;

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
              trailingWidget: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AuthColors.primary.withAlpha(26),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.security,
                  color: AuthColors.primary,
                  size: 20,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    if (_primaryMember != null)
                      SendOtpSelectedMemberCard(
                        name: _primaryMember!.name,
                        imageUrl: _primaryMember!.imageUrl ?? '',
                      ),
                    const SizedBox(height: 36),
                    Text(
                      'Security Verification',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: colors.onSurface,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please enter the phone number associated with this identity to receive your secure access code.',
                      style: TextStyle(
                        fontSize: 13,
                        color: colors.onSurfaceVariant,
                        height: 1.55,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 28),
                    SendOtpPhoneInput(controller: _phoneController),
                    const SizedBox(height: 18),
                    const SendOtpTrustMessage(),
                    const SizedBox(height: 32),
                    AuthSubmitButton(
                      label: 'Send Access Code',
                      trailingIcon: Icons.arrow_forward,
                      onTap: _isLoading ? () {} : _onSendOtp,
                    ),
                    const SizedBox(height: 48),
                    const Center(child: SendOtpFooterBadge()),
                    const SizedBox(height: 32),
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
