import 'package:alai_oosai/features/home/data/models.dart';
import 'package:alai_oosai/features/home/presentation/card_footer.dart';
import 'package:alai_oosai/features/home/presentation/tag_chip.dart';
import 'package:flutter/material.dart';
import 'package:alai_oosai/core/constants/app_constants.dart';

class CardBody extends StatelessWidget {
  final EventModel event;
  final bool isPressed;
  final VoidCallback onButtonTapDown;
  final VoidCallback onButtonTapUp;
  final VoidCallback? onButtonTap;

  const CardBody({
    super.key,
    required this.event,
    required this.isPressed,
    required this.onButtonTapDown,
    required this.onButtonTapUp,
    this.onButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TagChip(label: event.tag, color: event.tagColor),
          const SizedBox(height: 10),
          Text(
            event.title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: AppColors.slate900,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            event.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.slate600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CardFooter(event: event),
              if (event.buttonLabel.isNotEmpty)
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: (_) => onButtonTapDown(),
                  onTapUp: (_) => onButtonTapUp(),
                  onTapCancel: onButtonTapUp,
                  onTap: onButtonTap,
                  child: AnimatedScale(
                    scale: isPressed ? 0.95 : 1.0,
                    duration: const Duration(milliseconds: 100),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: event.buttonColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        event.buttonLabel,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
