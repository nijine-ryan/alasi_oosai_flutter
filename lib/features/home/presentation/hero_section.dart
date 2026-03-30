import 'package:alai_oosai/features/home/presentation/custom_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:alai_oosai/core/constants/app_constants.dart';

// ─── Hero / Search Section ────────────────────────────────────────────────────
class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome back,',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: AppColors.slate900,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Making a difference together in your city.',
            style: TextStyle(fontSize: 14, color: AppColors.slate500),
          ),
          const SizedBox(height: 16),
          CustomSearchBar(),
        ],
      ),
    );
  }
}
