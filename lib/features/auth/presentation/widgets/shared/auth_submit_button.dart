import 'package:flutter/material.dart';
import 'package:alai_oosai/features/auth/data/auth_colors.dart';

class AuthSubmitButton extends StatefulWidget {
  final String label;
  final IconData? trailingIcon;
  final VoidCallback onTap;

  const AuthSubmitButton({
    super.key,
    required this.label,
    this.trailingIcon,
    required this.onTap,
  });

  @override
  State<AuthSubmitButton> createState() => AuthSubmitButtonState();
}

class AuthSubmitButtonState extends State<AuthSubmitButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          width: double.infinity,
          height: 58,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AuthColors.gradientStart, AuthColors.gradientEnd],
            ),
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: AuthColors.primary.withAlpha(80),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.2,
                ),
              ),
              if (widget.trailingIcon != null) ...[
                const SizedBox(width: 10),
                Icon(widget.trailingIcon, color: Colors.white, size: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
