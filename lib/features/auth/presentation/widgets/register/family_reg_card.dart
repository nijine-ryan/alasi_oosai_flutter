import 'package:flutter/material.dart';
import 'package:alai_oosai/features/auth/data/auth_colors.dart';
import 'package:alai_oosai/features/auth/data/village_model.dart';
import 'package:alai_oosai/features/auth/presentation/widgets/register/family_reg_input_field.dart';
import 'package:alai_oosai/features/auth/presentation/widgets/register/village_dropdown.dart';
import 'package:alai_oosai/features/auth/presentation/widgets/shared/auth_submit_button.dart';

class FamilyRegCard extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isFocused;
  final String? selectedVillage;
  final List<VillageModel> villages;
  final bool isLoading;
  final ValueChanged<String?> onVillageChanged;
  final VoidCallback onSubmit;
  final bool isVerifying;
  final String? errorText;
  final VoidCallback? onVerify;

  const FamilyRegCard({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isFocused,
    required this.selectedVillage,
    required this.villages,
    this.isLoading = false,
    required this.onVillageChanged,
    required this.onSubmit,
    this.isVerifying = false,
    this.errorText,
    this.onVerify,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AuthColors.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: colors.surfaceBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Dropdown above the reg number input ──
          VillageDropdown(
            selectedVillage: selectedVillage,
            villages: villages,
            isLoading: isLoading,
            onChanged: onVillageChanged,
          ),
          const SizedBox(height: 28),
          // ── Divider between fields ───────────────
          Divider(color: colors.outlineVariant, height: 1),
          const SizedBox(height: 28),
          // ── Registration number input ────────────
          FamilyRegInputField(
            controller: controller,
            focusNode: focusNode,
            isFocused: isFocused,
            errorText: errorText,
          ),
          const SizedBox(height: 32),
          AuthSubmitButton(
            label: isVerifying ? 'Verifying...' : 'Verify',
            trailingIcon: Icons.chevron_right,
            onTap: isVerifying
                ? () {}
                : () {
                    if (onVerify != null) {
                      onVerify!();
                    } else {
                      onSubmit();
                    }
                  },
          ),
        ],
      ),
    );
  }
}
