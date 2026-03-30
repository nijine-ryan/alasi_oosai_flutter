import 'package:alai_oosai/core/constants/app_constants.dart';
import 'package:alai_oosai/features/home/data/sample_data.dart';
import 'package:alai_oosai/features/home/presentation/events_section.dart';
import 'package:alai_oosai/features/home/presentation/hero_section.dart';
import 'package:alai_oosai/widgets/app_header.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const AppHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    const HeroSection(),
                    const SizedBox(height: 32),
                    EventsSection(events: sampleEvents),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
