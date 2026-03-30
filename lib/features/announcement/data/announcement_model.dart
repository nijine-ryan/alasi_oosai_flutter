enum AnnouncementType { video, audio, image }

class AnnouncementModel {
  final String title;
  final String description;
  final String time;
  final AnnouncementType type;
  final String? mediaUrl;
  final String? videoDuration;
  final String? audioCurrentTime;
  final String? audioTotalTime;
  final double? audioProgress;

  const AnnouncementModel({
    required this.title,
    required this.description,
    required this.time,
    required this.type,
    this.mediaUrl,
    this.videoDuration,
    this.audioCurrentTime,
    this.audioTotalTime,
    this.audioProgress,
  });
}

class AnnouncementGroup {
  final String dateLabel;
  final List<AnnouncementModel> announcements;

  const AnnouncementGroup({
    required this.dateLabel,
    required this.announcements,
  });
}
