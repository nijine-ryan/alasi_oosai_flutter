import 'package:flutter/material.dart';
import 'package:alai_oosai/features/auth/data/auth_colors.dart';

class LoginPhoneInput extends StatefulWidget {
  final TextEditingController controller;

  const LoginPhoneInput({super.key, required this.controller});

  @override
  State<LoginPhoneInput> createState() => LoginPhoneInputState();
}

class LoginPhoneInputState extends State<LoginPhoneInput> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(
      () => setState(() => _isFocused = _focusNode.hasFocus),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AuthColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PHONE NUMBER',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AuthColors.primary,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: colors.surfaceContainer,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _isFocused
                  ? AuthColors.primary.withAlpha(128)
                  : colors.outlineVariant,
              width: _isFocused ? 1.5 : 1,
            ),
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            keyboardType: TextInputType.phone,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: colors.onSurface,
              letterSpacing: 2.0,
            ),
            decoration: InputDecoration(
              hintText: '555 012 3456',
              hintStyle: TextStyle(
                color: colors.inputPlaceholder,
                fontSize: 20,
                fontWeight: FontWeight.w400,
                letterSpacing: 2.0,
              ),
              border: InputBorder.none,
              isCollapsed: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
