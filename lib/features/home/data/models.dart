import 'package:flutter/material.dart';
import 'package:alai_oosai/core/constants/app_constants.dart';

class EventModel {
  final String id;
  final String imageUrl;
  final String month;
  final String day;
  final String tag;
  final Color tagColor;
  final String title;
  final String description;
  final EventFooterType footerType;
  final String footerText;
  final String buttonLabel;
  final Color buttonColor;
  final bool isWishlisted;
  final int joinedCount;

  const EventModel({
    this.id = '',
    required this.imageUrl,
    required this.month,
    required this.day,
    required this.tag,
    required this.tagColor,
    required this.title,
    required this.description,
    required this.footerType,
    required this.footerText,
    required this.buttonLabel,
    required this.buttonColor,
    this.isWishlisted = false,
    this.joinedCount = 0,
  });

  static const _monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  factory EventModel.fromApi(Map<String, dynamic> json) {
    final time = DateTime.tryParse(json['time'] as String? ?? '') ?? DateTime.now();
    final month = _monthNames[time.month - 1];
    final day = time.day.toString().padLeft(2, '0');
    final tags = (json['tags'] as List?)?.cast<String>() ?? [];
    final tag = tags.isNotEmpty ? tags.first : '';
    final type = json['type'] as String? ?? 'event';
    final joinedCount = json['joinedCount'] as int? ?? 0;
    final place = json['place'] as String? ?? '';
    final ctaText = json['ctaText'] as String? ?? 'Join';
    final isEvent = type == 'event';

    return EventModel(
      id: json['id'] as String? ?? '',
      imageUrl: json['image'] as String? ?? '',
      month: month,
      day: day,
      tag: tag,
      tagColor: AppColors.primary,
      title: json['title'] as String? ?? '',
      description: place,
      footerType: isEvent ? EventFooterType.avatars : EventFooterType.location,
      footerText: isEvent ? '+$joinedCount' : place,
      buttonLabel: isEvent ? ctaText : '',
      buttonColor: AppColors.primary,
      isWishlisted: json['isWishlisted'] as bool? ?? false,
      joinedCount: joinedCount,
    );
  }
}

enum EventFooterType { avatars, location, group }
