import 'package:alai_oosai/features/home/data/event_service.dart';
import 'package:alai_oosai/features/home/data/models.dart';
import 'package:alai_oosai/features/home/presentation/card_body.dart';
import 'package:alai_oosai/features/home/presentation/card_image.dart';
import 'package:flutter/material.dart';

class EventCard extends StatefulWidget {
  final EventModel event;
  final VoidCallback? onTap;

  const EventCard({super.key, required this.event, this.onTap});

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  late bool _isFavorite;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.event.isWishlisted;
  }

  Future<void> _toggleWishlist() async {
    final id = widget.event.id;
    final newState = !_isFavorite;
    setState(() => _isFavorite = newState);
    if (id.isEmpty) return;
    try {
      if (newState) {
        await EventService.addWishlist(id);
      } else {
        await EventService.removeWishlist(id);
      }
    } catch (_) {
      if (mounted) setState(() => _isFavorite = !newState);
    }
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.event;
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
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
              onFavTap: _toggleWishlist,
            ),
            CardBody(
              event: e,
              isPressed: _isPressed,
              onButtonTapDown: () => setState(() => _isPressed = true),
              onButtonTapUp: () => setState(() => _isPressed = false),
              onButtonTap: widget.onTap,
            ),
          ],
        ),
      ),
    );
  }
}
