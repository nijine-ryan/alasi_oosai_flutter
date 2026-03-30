import 'package:alai_oosai/features/announcement/data/announcement_model.dart';
import 'package:alai_oosai/features/announcement/presentation/widgets/announcement_audio_player.dart';
import 'package:alai_oosai/features/announcement/presentation/widgets/announcement_image_media.dart';
import 'package:flutter/material.dart';
import 'package:alai_oosai/core/constants/app_constants.dart';
import 'video_thumbnail.dart';

class AnnouncementCard extends StatelessWidget {
  final AnnouncementModel announcement;

  const AnnouncementCard({super.key, required this.announcement});

  Widget buildMediaSection(AnnouncementModel a) {
    switch (a.type) {
      case AnnouncementType.video:
        return VideoThumbnail(
          imageUrl: a.mediaUrl!,
          duration: a.videoDuration!,
        );
      case AnnouncementType.audio:
        return AnnouncementAudioPlayer(
          currentTime: a.audioCurrentTime!,
          totalTime: a.audioTotalTime!,
          progress: a.audioProgress!,
        );
      case AnnouncementType.image:
        return AnnouncementImageMedia(imageUrl: a.mediaUrl!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.slate100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              announcement.title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.slate900,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              announcement.description,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.slate600,
                height: 1.55,
              ),
            ),
            const SizedBox(height: 12),
            buildMediaSection(announcement),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                announcement.time.toUpperCase(),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.slate400,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
