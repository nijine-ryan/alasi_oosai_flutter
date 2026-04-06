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
        child: imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _placeholder(),
                loadingBuilder: (_, child, progress) => progress == null
                    ? child
                    : Container(
                        color: AppColors.slate200,
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.slate400,
                          ),
                        ),
                      ),
              )
            : _placeholder(),
      ),
    );
  }

  Widget _placeholder() => Container(
        color: AppColors.slate200,
        child: const Center(
          child: Icon(Icons.image_outlined, size: 36, color: AppColors.slate400),
        ),
      );
}
