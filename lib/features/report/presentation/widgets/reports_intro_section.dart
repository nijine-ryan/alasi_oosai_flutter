import 'package:flutter/material.dart';
import 'package:alai_oosai/core/constants/app_constants.dart';

class ReportsIntroSection extends StatelessWidget {
  const ReportsIntroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Financial Transparency',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.slate900,
            letterSpacing: -0.3,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Detailed accounts of community fund allocations and project expenditures.',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.slate500,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
