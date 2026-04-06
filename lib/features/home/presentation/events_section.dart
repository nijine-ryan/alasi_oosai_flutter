import 'package:alai_oosai/features/home/data/models.dart';
import 'package:alai_oosai/features/home/presentation/event_card.dart';
import 'package:alai_oosai/features/home/presentation/event_detail_screen.dart';
import 'package:flutter/material.dart';

class EventsSection extends StatelessWidget {
  final List<EventModel> events;
  const EventsSection({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    if (events.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 32),
        child: Center(
          child: Text(
            'No upcoming events.',
            style: TextStyle(color: cs.onSurfaceVariant, fontSize: 14),
          ),
        ),
      );
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Text(
            'Upcoming Events',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: cs.onSurface,
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...events.map(
          (e) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: EventCard(
              event: e,
              onTap: e.id.isNotEmpty
                  ? () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EventDetailScreen(eventId: e.id),
                        ),
                      )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
