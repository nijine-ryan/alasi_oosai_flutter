import 'package:alai_oosai/core/constants/app_constants.dart';
import 'package:alai_oosai/features/home/data/models.dart';
import 'package:flutter/material.dart';

class CardImage extends StatelessWidget {
  final EventModel event;
  final bool isFavorite;
  final VoidCallback onFavTap;

  const CardImage({
    super.key,
    required this.event,
    required this.isFavorite,
    required this.onFavTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 192,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            event.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: AppColors.slate200),
            loadingBuilder: (_, child, progress) =>
                progress == null ? child : Container(color: AppColors.slate200),
          ),
          // Date badge
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.white.withAlpha(230),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 4),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    event.month.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: event.tagColor,
                      letterSpacing: 0.8,
                    ),
                  ),
                  Text(
                    event.day,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppColors.slate900,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Favorite button
          Positioned(
            top: 12,
            right: 12,
            child: GestureDetector(
              onTap: onFavTap,
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.white.withAlpha(230),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 4),
                  ],
                ),
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  size: 18,
                  color: isFavorite ? Colors.red : AppColors.slate400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
