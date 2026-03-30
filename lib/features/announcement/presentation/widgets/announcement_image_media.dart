import 'package:flutter/material.dart';
import 'package:alai_oosai/core/constants/app_constants.dart';

class AnnouncementImageMedia extends StatelessWidget {
  final String imageUrl;

  const AnnouncementImageMedia({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: 160,
        width: double.infinity,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(color: AppColors.slate200),
          loadingBuilder: (_, child, progress) =>
              progress == null ? child : Container(color: AppColors.slate200),
        ),
      ),
    );
  }
}
