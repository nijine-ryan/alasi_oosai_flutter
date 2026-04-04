import 'package:alai_oosai/features/report/data/report_model.dart';
import 'package:alai_oosai/features/report/data/report_service.dart';
import 'package:alai_oosai/features/report/presentation/widgets/report_card.dart';
import 'package:alai_oosai/features/report/presentation/widgets/reports_header.dart';
import 'package:alai_oosai/features/report/presentation/widgets/reports_intro_section.dart';
import 'package:alai_oosai/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:alai_oosai/core/constants/app_constants.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  List<ReportModel> _reports = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchReports();
    SocketService.onReportNew(_onSocketReport);
  }

  @override
  void dispose() {
    SocketService.offReportNew(_onSocketReport);
    super.dispose();
  }

  void _onSocketReport(Map<String, dynamic> data) {
    _fetchReports();
  }

  Future<void> _fetchReports() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final items = await ReportService.fetchReports();
      if (!mounted) return;
      setState(() => _reports = items);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
              child: _buildBody(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              TextButton(onPressed: _fetchReports, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _fetchReports,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
        children: [
          const ReportsIntroSection(),
          const SizedBox(height: 24),
          if (_reports.isEmpty)
            const Center(child: Text('No reports available.'))
          else
            ..._reports.map(
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
    );
  }
}
