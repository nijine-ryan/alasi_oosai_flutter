import 'package:alai_oosai/features/announcement/data/announcement_data.dart';
import 'package:alai_oosai/features/announcement/presentation/widgets/announcement_group_section.dart';
import 'package:alai_oosai/features/announcement/presentation/widgets/announcements_header.dart';
import 'package:flutter/material.dart';
import 'package:alai_oosai/core/constants/app_constants.dart';

class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const AnnouncementsHeader(),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 16,
                ),
                itemCount: announcementGroups.length,
                separatorBuilder: (_, __) => const SizedBox(height: 32),
                itemBuilder: (context, index) =>
                    AnnouncementGroupSection(group: announcementGroups[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
