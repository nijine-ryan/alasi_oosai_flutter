enum AnnouncementType {
  video,
  audio,
  image,
  /// Text-only — no media attachment.
  none,
}

class AnnouncementModel {
  final String id;
  final String title;
  final String description;
  /// Formatted display time derived from createdAt (e.g. "3:45 PM").
  final String time;
  /// Formatted date label for grouping derived from createdAt (e.g. "14 March 2026").
  final String dateLabel;
  /// Raw creation timestamp — used for client-side sorting.
  final DateTime? createdAt;
  final AnnouncementType type;
  final String? mediaUrl;
  final String? videoDuration;
  final String? audioCurrentTime;
  final String? audioTotalTime;
  final double? audioProgress;

  const AnnouncementModel({
    this.id = '',
    required this.title,
    required this.description,
    required this.time,
    this.dateLabel = '',
    this.createdAt,
    required this.type,
    this.mediaUrl,
    this.videoDuration,
    this.audioCurrentTime,
    this.audioTotalTime,
    this.audioProgress,
  });

  /// Parses an announcement from the API response item.
  ///
  /// API shape:
  /// ```json
  /// { "id": "...", "title": "...", "description": "...",
  ///   "time": "2026-04-15T10:00:00.000Z",
  ///   "video": "url?", "image": "url?", "voiceNote": "url?" }
  /// ```
  factory AnnouncementModel.fromApi(Map<String, dynamic> json) {
    // Use createdAt for badge display and grouping; fall back to time if absent.
    final createdAtStr = json['createdAt'] as String?;
    final fallbackStr = json['time'] as String?;
    final rawStr = (createdAtStr?.isNotEmpty == true ? createdAtStr : fallbackStr) ?? '';

    String formattedTime = '';
    String dateLabel = '';
    DateTime? createdAt;

    try {
      final dt = DateTime.parse(rawStr).toLocal();
      createdAt = dt;
      final hour = dt.hour;
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      final h = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      formattedTime = '$h:$minute $period';

      const months = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December',
      ];
      dateLabel = '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      // Unparseable time — leave empty strings.
    }

    // Media priority: video > image > voiceNote.
    AnnouncementType type;
    String? mediaUrl;
    if (json['video'] != null) {
      type = AnnouncementType.video;
      mediaUrl = json['video'] as String?;
    } else if (json['image'] != null) {
      type = AnnouncementType.image;
      mediaUrl = json['image'] as String?;
    } else if (json['voiceNote'] != null) {
      type = AnnouncementType.audio;
      mediaUrl = json['voiceNote'] as String?;
    } else {
      type = AnnouncementType.none;
    }

    return AnnouncementModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      time: formattedTime,
      dateLabel: dateLabel,
      createdAt: createdAt,
      type: type,
      mediaUrl: mediaUrl,
      audioCurrentTime: type == AnnouncementType.audio ? '0:00' : null,
      audioTotalTime: type == AnnouncementType.audio ? '0:00' : null,
      audioProgress: type == AnnouncementType.audio ? 0.0 : null,
    );
  }
}

class AnnouncementGroup {
  final String dateLabel;
  final List<AnnouncementModel> announcements;

  const AnnouncementGroup({
    required this.dateLabel,
    required this.announcements,
  });
}
