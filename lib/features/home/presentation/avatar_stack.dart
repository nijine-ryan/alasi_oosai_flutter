import 'package:alai_oosai/core/constants/app_constants.dart';
import 'package:alai_oosai/features/home/data/sample_data.dart';
import 'package:flutter/material.dart';

class AvatarStackFooter extends StatelessWidget {
  final String extraCount;
  const AvatarStackFooter({super.key, required this.extraCount});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: Row(
        children: [
          SizedBox(
            width: 56,
            child: Stack(
              children: [
                ...attendeeAvatars.asMap().entries.map(
                  (entry) => Positioned(
                    left: entry.key * 20.0,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 2),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          entry.value,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Container(color: AppColors.slate200),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.slate300,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white, width: 2),
            ),
            child: Center(
              child: Text(
                extraCount,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: AppColors.slate700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
