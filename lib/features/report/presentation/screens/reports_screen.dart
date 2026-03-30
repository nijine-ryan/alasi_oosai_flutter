import 'package:alai_oosai/features/report/data/report_data.dart';
import 'package:alai_oosai/features/report/presentation/widgets/report_card.dart';
import 'package:alai_oosai/features/report/presentation/widgets/reports_header.dart';
import 'package:alai_oosai/features/report/presentation/widgets/reports_intro_section.dart';
import 'package:flutter/material.dart';
import 'package:alai_oosai/core/constants/app_constants.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const ReportsHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
                children: [
                  const ReportsIntroSection(),
                  const SizedBox(height: 24),
                  ...reportsList.map(
                    (report) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ReportCard(
                        report: report,
                        onView: () {
                          // TODO: open PDF viewer
                        },
                        onDownload: () {
                          // TODO: trigger download
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
