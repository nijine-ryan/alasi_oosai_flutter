import 'package:flutter/material.dart';
import 'package:alai_oosai/core/constants/app_constants.dart';
import 'announcements_header_icon_button.dart';

class AnnouncementsHeader extends StatelessWidget {
  final bool hasNew;

  const AnnouncementsHeader({super.key, this.hasNew = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        children: [
          AnnouncementsHeaderIconButton(
            icon: Icons.arrow_back,
            onTap: () => Navigator.maybePop(context),
          ),
          const Expanded(
            child: Text(
              'Announcements',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.slate900,
              ),
            ),
          ),
          Stack(
            children: [
              AnnouncementsHeaderIconButton(
                icon: Icons.notifications_outlined,
                onTap: () {},
              ),
              if (hasNew)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
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
