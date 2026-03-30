import 'package:flutter/material.dart';
import 'package:alai_oosai/features/auth/data/auth_colors.dart';

class MemberListBottomBar extends StatefulWidget {
  final int selectedCount;
  final VoidCallback onContinue;
  final VoidCallback onSkip;
  final String? continueLabel;

  const MemberListBottomBar({
    super.key,
    required this.selectedCount,
    required this.onContinue,
    required this.onSkip,
    this.continueLabel,
  });

  @override
  State<MemberListBottomBar> createState() => MemberListBottomBarState();
}

class MemberListBottomBarState extends State<MemberListBottomBar> {
  bool _pressed = false;

  bool get _hasSelection => widget.selectedCount > 0;

  @override
  Widget build(BuildContext context) {
    final colors = AuthColors.of(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            colors.background,
            colors.background,
            colors.background.withAlpha(0),
          ],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTapDown: _hasSelection
                ? (_) => setState(() => _pressed = true)
                : null,
            onTapUp: _hasSelection
                ? (_) => setState(() => _pressed = false)
                : null,
            onTapCancel: _hasSelection
                ? () => setState(() => _pressed = false)
                : null,
            onTap: _hasSelection ? widget.onContinue : null,
            child: AnimatedScale(
              scale: _pressed ? 0.97 : 1.0,
              duration: const Duration(milliseconds: 120),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                height: 58,
                decoration: BoxDecoration(
                  gradient: _hasSelection
                      ? const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AuthColors.gradientStart,
                            AuthColors.gradientEnd,
                          ],
                        )
                      : null,
                  color: _hasSelection ? null : colors.surfaceContainer,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: _hasSelection
                      ? [
                          BoxShadow(
                            color: AuthColors.primary.withAlpha(60),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ]
                      : [],
                ),
                alignment: Alignment.center,
                child: Text(
                  _hasSelection
                      ? (widget.continueLabel ?? 'Continue with 1 Member')
                      : 'Select a Member',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: _hasSelection ? Colors.white : colors.onSurfaceMuted,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: widget.onSkip,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'SKIP FOR NOW',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AuthColors.primary,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
