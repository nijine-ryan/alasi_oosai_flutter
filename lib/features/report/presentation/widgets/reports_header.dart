import 'package:flutter/material.dart';
import 'package:alai_oosai/core/constants/app_constants.dart';

class ReportsHeader extends StatelessWidget {
  const ReportsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.white,

        border: Border(bottom: BorderSide(color: AppColors.slate200)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: const Icon(
                Icons.arrow_back,
                color: AppColors.slate600,
                size: 24,
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'Monthly Reports',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.slate900,
              ),
            ),
          ),
          // Spacer to balance the back button and keep title centered
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}
