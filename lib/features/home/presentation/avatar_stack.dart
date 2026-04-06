import 'package:alai_oosai/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

class AvatarStackFooter extends StatelessWidget {
  final String extraCount;
  const AvatarStackFooter({super.key, required this.extraCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.slate100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.people_outline, size: 14, color: AppColors.slate500),
          const SizedBox(width: 5),
          Text(
            '$extraCount joined',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.slate600,
            ),
          ),
        ],
      ),
    );
  }
}
