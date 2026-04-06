import 'package:alai_oosai/features/report/data/report_model.dart';
import 'package:alai_oosai/features/report/presentation/widgets/report_card_actions.dart';
import 'package:alai_oosai/features/report/presentation/widgets/report_card_info.dart';
import 'package:flutter/material.dart';

class ReportCard extends StatelessWidget {
  final ReportModel report;
  final VoidCallback? onView;
  final VoidCallback? onDownload;

  const ReportCard({
    super.key,
    required this.report,
    this.onView,
    this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ReportCardInfo(report: report),
          ReportCardActions(onView: onView, onDownload: onDownload),
        ],
      ),
    );
  }
}
