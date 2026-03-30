import 'package:flutter/material.dart';
import 'package:alai_oosai/features/auth/data/auth_colors.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final Widget? trailingWidget;
  final bool showBack;

  const AuthHeader({
    super.key,
    required this.title,
    this.trailingWidget,
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AuthColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: showBack
                ? GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: Icon(
                      Icons.arrow_back,
                      color: colors.onSurface,
                      size: 22,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: colors.onSurface,
                letterSpacing: -0.3,
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: trailingWidget != null
                ? Align(alignment: Alignment.centerRight, child: trailingWidget)
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
