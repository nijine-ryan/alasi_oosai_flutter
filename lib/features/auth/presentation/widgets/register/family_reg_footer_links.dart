import 'package:flutter/material.dart';
import 'package:alai_oosai/features/auth/data/auth_colors.dart';

class FamilyRegFooterLinks extends StatelessWidget {
  const FamilyRegFooterLinks({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FamilyRegFooterLink(
          icon: Icons.help_outline,
          label: 'Where can I find my number?',
          onTap: () {},
        ),
        const SizedBox(height: 28),
        FamilyRegFooterLink(
          icon: Icons.mail_outline,
          label: 'Contact Estate Manager',
          onTap: () {},
        ),
      ],
    );
  }
}

class FamilyRegFooterLink extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const FamilyRegFooterLink({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AuthColors.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: colors.onSurfaceMuted, size: 20),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              color: colors.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
