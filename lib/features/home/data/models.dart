import 'package:flutter/material.dart';

class EventModel {
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

  const EventModel({
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
  });
}

enum EventFooterType { avatars, location, group }
