import 'package:flutter/material.dart';

class ReportsHeader extends StatelessWidget {
  const ReportsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(bottom: BorderSide(color: cs.outlineVariant)),
      ),
      alignment: Alignment.center,
      child: Text(
        'Monthly Reports',
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: cs.onSurface,
        ),
      ),
    );
  }
}
