import 'package:flutter/material.dart';

class AnnouncementsHeader extends StatelessWidget {
  final bool hasNew;

  const AnnouncementsHeader({super.key, this.hasNew = false});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      color: cs.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      alignment: Alignment.center,
      child: Text(
        'Announcements',
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: cs.onSurface,
        ),
      ),
    );
  }
}
