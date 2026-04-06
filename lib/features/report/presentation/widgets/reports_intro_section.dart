import 'package:flutter/material.dart';

class ReportsIntroSection extends StatelessWidget {
  const ReportsIntroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Financial Transparency',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: cs.onSurface,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Detailed accounts of community fund allocations and project expenditures.',
          style: TextStyle(
            fontSize: 13,
            color: cs.onSurfaceVariant,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
