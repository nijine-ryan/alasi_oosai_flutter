import 'package:alai_oosai/features/home/data/models.dart';
import 'package:alai_oosai/features/home/presentation/event_card.dart';
import 'package:flutter/material.dart';
import 'package:alai_oosai/core/constants/app_constants.dart';

class EventsSection extends StatelessWidget {
  final List<EventModel> events;
  const EventsSection({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Upcoming Events',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.slate800,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'See All',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...events.map(
          (e) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: EventCard(event: e),
          ),
        ),
      ],
    );
  }
}
