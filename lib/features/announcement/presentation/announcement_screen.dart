import 'package:flutter/material.dart';
import 'package:alai_oosai/core/constants/app_constants.dart';
import 'package:alai_oosai/features/announcement/data/announcement_model.dart';
import 'package:alai_oosai/features/announcement/data/announcement_service.dart';
import 'package:alai_oosai/services/socket_service.dart';
import 'widgets/announcements_header.dart';
import 'widgets/announcement_group_section.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  List<AnnouncementGroup> _groups = [];
  bool _isLoading = true;
  String? _error;
  bool _hasNew = false;

  @override
  void initState() {
    super.initState();
    _fetchAnnouncements();
    SocketService.onAnnouncementNew(_onSocketAnnouncement);
  }

  @override
  void dispose() {
    SocketService.offAnnouncementNew(_onSocketAnnouncement);
    super.dispose();
  }

  // ─── Socket ─────────────────────────────────────────────────────────────────

  void _onSocketAnnouncement(Map<String, dynamic> data) {
    if (!mounted) return;
    // Mark unread badge and refresh list from API.
    setState(() => _hasNew = true);
    _fetchAnnouncements();
  }

  // ─── API ─────────────────────────────────────────────────────────────────────

  Future<void> _fetchAnnouncements() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final items = await AnnouncementService.fetchAnnouncements();
      if (!mounted) return;
      setState(() {
        _groups = _groupByDate(items);
        _hasNew = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ─── Grouping ────────────────────────────────────────────────────────────────

  List<AnnouncementGroup> _groupByDate(List<AnnouncementModel> items) {
    // Sort newest first by createdAt, then group by dateLabel.
    final sorted = [...items]..sort((a, b) {
        if (a.createdAt == null && b.createdAt == null) return 0;
        if (a.createdAt == null) return 1;
        if (b.createdAt == null) return -1;
        return a.createdAt!.compareTo(b.createdAt!);
      });
    final keys = <String>[];
    final map = <String, List<AnnouncementModel>>{};
    for (final item in sorted) {
      final label = item.dateLabel.isNotEmpty ? item.dateLabel : 'Today';
      if (!map.containsKey(label)) {
        keys.add(label);
        map[label] = [];
      }
      map[label]!.add(item);
    }
    return keys
        .map((k) => AnnouncementGroup(dateLabel: k, announcements: map[k]!))
        .toList();
  }

  // ─── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AnnouncementsHeader(hasNew: _hasNew),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _groups.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null && _groups.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_rounded, size: 48, color: AppColors.slate400),
              const SizedBox(height: 16),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.slate600, fontSize: 14),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _fetchAnnouncements,
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
    }

    if (!_isLoading && _groups.isEmpty) {
      return const Center(
        child: Text(
          'No announcements yet.',
          style: TextStyle(color: AppColors.slate400, fontSize: 14),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchAnnouncements,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        itemCount: _groups.length,
        separatorBuilder: (context, i) => const SizedBox(height: 32),
        itemBuilder: (context, index) =>
            AnnouncementGroupSection(group: _groups[index]),
      ),
    );
  }
}
