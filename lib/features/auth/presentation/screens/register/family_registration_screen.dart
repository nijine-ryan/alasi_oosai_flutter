import 'package:flutter/material.dart';
import 'package:alai_oosai/features/auth/data/auth_colors.dart';
import 'package:alai_oosai/features/auth/presentation/widgets/shared/auth_header.dart';
import 'package:alai_oosai/features/auth/presentation/widgets/register/family_reg_headline.dart';
import 'package:alai_oosai/features/auth/presentation/widgets/register/family_reg_card.dart';
import 'package:alai_oosai/features/auth/presentation/widgets/register/family_reg_footer_links.dart';
import 'package:alai_oosai/features/auth/presentation/screens/register/family_member_list_screen.dart';
import 'package:alai_oosai/features/auth/data/village_service.dart';
import 'package:alai_oosai/features/auth/data/family_registration_service.dart';
import 'package:alai_oosai/features/auth/data/village_model.dart';

class FamilyRegistrationScreen extends StatefulWidget {
  const FamilyRegistrationScreen({super.key});

  @override
  State<FamilyRegistrationScreen> createState() =>
      FamilyRegistrationScreenState();
}

class FamilyRegistrationScreenState extends State<FamilyRegistrationScreen> {
  final TextEditingController _regController = TextEditingController();
  final FocusNode _regFocusNode = FocusNode();
  bool _isFocused = false;
  String? _selectedVillageId;
  List<VillageModel>? _apiVillages;
  bool _isLoadingVillages = true;
  bool _isVerifying = false;
  String? _fieldError;

  @override
  void initState() {
    super.initState();
    _regFocusNode.addListener(() {
      setState(() => _isFocused = _regFocusNode.hasFocus);
    });

    // Fetch villages from API; fall back to empty list on error
    VillageService.fetchVillages()
        .then((list) {
          if (mounted) {
            setState(() {
              _apiVillages = list;
              _isLoadingVillages = false;
            });
          }
        })
        .catchError((err) {
          // Show error and keep villages empty
          print('Error fetching villages: $err');
          if (mounted) {
            setState(() => _isLoadingVillages = false);
            final ms = err?.toString() ?? 'Failed to load villages.';
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(ms)));
            });
          }
        });
  }

  @override
  void dispose() {
    _regController.dispose();
    _regFocusNode.dispose();
    super.dispose();
  }

  // Both fields must be filled to proceed
  bool get _canSubmit =>
      _selectedVillageId != null && _regController.text.trim().isNotEmpty;

  void _onSubmit() {
    if (!_canSubmit) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FamilyMemberListScreen(
          villageId: _selectedVillageId!,
          familyCardNumber: _regController.text.trim(),
        ),
      ),
    );
  }

  void _onVerify() async {
    if (!_canSubmit || _isVerifying) return;
    setState(() {
      _isVerifying = true;
      _fieldError = null;
    });
    final villageId = _selectedVillageId;
    final regNum = _regController.text.trim();
    try {
      final result = await FamilyRegistrationService.verifyFamilyCard(
        villageId: villageId!,
        familyCardNumber: regNum,
      );
      if (!mounted) return;
      if (result.success) {
        // Success: navigate to next page (pass id if needed)
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FamilyMemberListScreen(
              villageId: villageId,
              familyCardNumber: regNum,
            ),
          ),
        );
      } else {
        setState(() {
          _fieldError =
              result.fieldErrors?['family_card_number']?.join(' ') ??
              result.message;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _fieldError = 'Server error. Please try again.';
      });
    } finally {
      if (mounted) setState(() => _isVerifying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AuthColors.of(context);
    final villages = _apiVillages ?? <VillageModel>[];
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            const AuthHeader(title: 'Community Trust'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 48),
                    const FamilyRegHeadline(),
                    const SizedBox(height: 56),
                    FamilyRegCard(
                      controller: _regController,
                      focusNode: _regFocusNode,
                      isFocused: _isFocused,
                      selectedVillage: _selectedVillageId,
                      villages: villages,
                      isLoading: _isLoadingVillages,
                      isVerifying: _isVerifying,
                      errorText: _fieldError,
                      onVerify: _onVerify,
                      onVillageChanged: (v) {
                        setState(() => _selectedVillageId = v);
                      },
                      onSubmit: _onSubmit,
                    ),
                    const SizedBox(height: 64),
                    const FamilyRegFooterLinks(),
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
