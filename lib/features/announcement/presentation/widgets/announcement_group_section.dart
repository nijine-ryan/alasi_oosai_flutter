import 'package:flutter/material.dart';
import 'package:alai_oosai/features/announcement/data/announcement_model.dart';
import 'date_chip.dart';
import 'announcement_card.dart';

class AnnouncementGroupSection extends StatelessWidget {
  final AnnouncementGroup
  group; // ✅ AnnouncementGroup, not AnnouncementGroupSection

  const AnnouncementGroupSection({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DateChip(label: group.dateLabel),
        const SizedBox(height: 16),
        ...group.announcements.map(
          (a) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: AnnouncementCard(announcement: a),
          ),
        ),
      ],
    );
  }
}
