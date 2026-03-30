import 'package:flutter/material.dart';
import 'package:alai_oosai/features/auth/data/auth_colors.dart';

class FamilyRegHeadline extends StatelessWidget {
  const FamilyRegHeadline({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AuthColors.of(context);
    return Column(
      children: [
        Text(
          'Secure Your\nFamily Legacy',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w800,
            color: colors.onSurface,
            height: 1.1,
            letterSpacing: -1.0,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Enter your unique family registration number\nto join your private circle.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: colors.onSurfaceVariant,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
