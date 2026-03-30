import 'package:flutter/material.dart';
import 'package:alai_oosai/features/auth/data/auth_colors.dart';

class FamilyRegInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isFocused;
  final String? errorText;

  const FamilyRegInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isFocused,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AuthColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'FAMILY REGISTRATION NUMBER',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AuthColors.primaryLabel,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 14),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: colors.inputBg,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: isFocused
                  ? colors.focusRing.withAlpha(128)
                  : Colors.transparent,
              width: isFocused ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 22, right: 8),
                child: Icon(
                  Icons.fingerprint,
                  color: colors.onSurfaceMuted,
                  size: 24,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                  decoration: InputDecoration(
                    hintText: 'e.g. TS-992-K81',
                    hintStyle: TextStyle(
                      color: colors.inputPlaceholder,
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    isCollapsed: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 20),
                    errorText: errorText,
                  ),
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
        ),
        if (errorText != null && errorText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 22, top: 6),
            child: Text(
              errorText!,
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Icon(
                Icons.verified_user_outlined,
                color: colors.onSurfaceMuted,
                size: 14,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Your registration key is case-sensitive and end-to-end encrypted.',
                style: TextStyle(
                  fontSize: 12,
                  color: colors.onSurfaceMuted,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
