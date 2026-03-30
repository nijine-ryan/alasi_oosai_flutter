import 'package:flutter/material.dart';
import 'package:alai_oosai/core/constants/app_constants.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications_outlined,
            color: AppColors.slate600,
          ),
          style: IconButton.styleFrom(
            backgroundColor: Colors.transparent,
            shape: const CircleBorder(),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white, width: 1),
            ),
          ),
        ),
      ],
    );
  }
}
