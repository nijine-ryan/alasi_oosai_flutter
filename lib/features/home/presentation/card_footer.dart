import 'package:alai_oosai/features/home/data/models.dart';
import 'package:alai_oosai/features/home/presentation/avatar_stack.dart';
import 'package:alai_oosai/features/home/presentation/icon_label.dart';
import 'package:flutter/material.dart';

class CardFooter extends StatelessWidget {
  final EventModel event;
  const CardFooter({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    switch (event.footerType) {
      case EventFooterType.avatars:
        return AvatarStackFooter(extraCount: event.footerText);
      case EventFooterType.location:
        return IconLabelFooter(
          icon: Icons.location_on_outlined,
          label: event.footerText,
        );
      case EventFooterType.group:
        return IconLabelFooter(
          icon: Icons.group_outlined,
          label: event.footerText,
        );
    }
  }
}
