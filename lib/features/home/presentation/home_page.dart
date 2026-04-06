import 'dart:async';
import 'package:alai_oosai/core/constants/app_constants.dart';
import 'package:alai_oosai/features/home/data/event_service.dart';
import 'package:alai_oosai/features/home/data/models.dart';
import 'package:alai_oosai/features/home/presentation/events_section.dart';
import 'package:alai_oosai/features/home/presentation/hero_section.dart';
import 'package:alai_oosai/features/home/presentation/home_drawer.dart';
import 'package:alai_oosai/widgets/app_header.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<EventModel> _events = [];
  bool _isLoading = true;
  String? _error;
  String _searchQuery = '';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearch(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _searchQuery = query;
      _loadEvents();
    });
  }

  Future<void> _loadEvents() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final events = await EventService.fetchEvents(search: _searchQuery.isEmpty ? null : _searchQuery);
      if (!mounted) return;
      setState(() => _events = events);
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
      drawer: const HomeDrawer(),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const AppHeader(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadEvents,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 80),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      HeroSection(onSearch: _onSearch),
                      const SizedBox(height: 32),
                      if (_isLoading)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 48),
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          ),
                        )
                      else if (_error != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 24,
                          ),
                          child: Column(
                            children: [
                              Text(
                                _error!,
                                style: const TextStyle(
                                  color: AppColors.slate500,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              TextButton(
                                onPressed: _loadEvents,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      else
                        EventsSection(events: _events),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
