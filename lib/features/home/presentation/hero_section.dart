import 'package:alai_oosai/features/auth/data/auth_service.dart';
import 'package:alai_oosai/features/home/presentation/custom_search_bar.dart';
import 'package:flutter/material.dart';

// ─── Hero / Search Section ────────────────────────────────────────────────────
class HeroSection extends StatelessWidget {
  final ValueChanged<String>? onSearch;

  const HeroSection({super.key, this.onSearch});

  @override
  Widget build(BuildContext context) {
    final name = AuthService.userName;
    final greeting = name != null && name.isNotEmpty ? 'Welcome back, $name!' : 'Welcome back,';
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            greeting,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: cs.onSurface,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Making a difference together in your city.',
            style: TextStyle(fontSize: 14, color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          CustomSearchBar(onChanged: onSearch),
        ],
      ),
    );
  }
}
