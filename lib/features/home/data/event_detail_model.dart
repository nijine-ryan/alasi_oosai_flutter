import 'package:alai_oosai/core/constants/env_config.dart';

class EventDetailUser {
  final String id;
  final String name;

  const EventDetailUser({required this.id, required this.name});

  factory EventDetailUser.fromJson(Map<String, dynamic> json) => EventDetailUser(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
      );
}

class EventDetailModel {
  final String id;
  final String title;
  final String description;
  final String place;
  final DateTime time;
  final String conductorName;
  final List<String> tags;
  final String type;
  final List<EventDetailUser> joinedUsers;
  final int joinedCount;
  final bool isJoined;
  final bool isWishlisted;
  final String ctaText;
  final String? image;

  const EventDetailModel({
    required this.id,
    required this.title,
    required this.description,
    required this.place,
    required this.time,
    required this.conductorName,
    required this.tags,
    required this.type,
    required this.joinedUsers,
    required this.joinedCount,
    required this.isJoined,
    required this.isWishlisted,
    required this.ctaText,
    this.image,
  });

  factory EventDetailModel.fromJson(Map<String, dynamic> json) {
    final raw = (json['joinedUsers'] as List?) ?? [];
    return EventDetailModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      place: json['place'] as String? ?? '',
      time: DateTime.tryParse(json['time'] as String? ?? '') ?? DateTime.now(),
      conductorName: json['conductorName'] as String? ?? '',
      tags: (json['tags'] as List?)?.cast<String>() ?? [],
      type: json['type'] as String? ?? 'event',
      joinedUsers: raw
          .map((u) => EventDetailUser.fromJson(u as Map<String, dynamic>))
          .toList(),
      joinedCount: json['joinedCount'] as int? ?? 0,
      isJoined: json['isJoined'] as bool? ?? false,
      isWishlisted: json['isWishlisted'] as bool? ?? false,
      ctaText: json['ctaText'] as String? ?? 'Join',
      image: EnvConfig.normalizeUrl(json['image'] as String?),
    );
  }

  String get formattedTime {
    final rawHour = time.hour;
    final hour = rawHour == 0 ? 12 : (rawHour > 12 ? rawHour - 12 : rawHour);
    final amPm = rawHour >= 12 ? 'PM' : 'AM';
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute $amPm';
  }

  String get formattedDate {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[time.month - 1]} ${time.day}, ${time.year}';
  }
}
