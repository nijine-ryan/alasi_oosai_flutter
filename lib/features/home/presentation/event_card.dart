import 'package:alai_oosai/features/home/data/models.dart';
import 'package:alai_oosai/features/home/presentation/card_body.dart';
import 'package:alai_oosai/features/home/presentation/card_image.dart';
import 'package:flutter/material.dart';
import 'package:alai_oosai/core/constants/app_constants.dart';

class EventCard extends StatefulWidget {
  final EventModel event;
  const EventCard({super.key, required this.event});

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool _isFavorite = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final e = widget.event;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.slate100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(18),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardImage(
            event: e,
            isFavorite: _isFavorite,
            onFavTap: () {
              setState(() => _isFavorite = !_isFavorite);
            },
          ),
          CardBody(
            event: e,
            isPressed: _isPressed,
            onButtonTapDown: () => setState(() => _isPressed = true),
            onButtonTapUp: () => setState(() => _isPressed = false),
          ),
        ],
      ),
    );
  }
}
