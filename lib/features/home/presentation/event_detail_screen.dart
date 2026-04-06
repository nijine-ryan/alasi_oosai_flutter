import 'package:alai_oosai/core/constants/app_constants.dart';
import 'package:alai_oosai/features/home/data/event_detail_model.dart';
import 'package:alai_oosai/features/home/data/event_service.dart';
import 'package:alai_oosai/features/home/presentation/tag_chip.dart';
import 'package:flutter/material.dart';

class EventDetailScreen extends StatefulWidget {
  final String eventId;
  const EventDetailScreen({super.key, required this.eventId});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  EventDetailModel? _event;
  bool _isLoading = true;
  String? _error;
  bool _isWishlisted = false;
  bool _isJoined = false;
  bool _isJoining = false;

  @override
  void initState() {
    super.initState();
    _loadEvent();
  }

  Future<void> _loadEvent() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final event = await EventService.fetchEventDetail(widget.eventId);
      if (!mounted) return;
      setState(() {
        _event = event;
        _isWishlisted = event.isWishlisted;
        _isJoined = event.isJoined;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleWishlist() async {
    final newState = !_isWishlisted;
    setState(() => _isWishlisted = newState);
    try {
      if (newState) {
        await EventService.addWishlist(widget.eventId);
      } else {
        await EventService.removeWishlist(widget.eventId);
      }
    } catch (_) {
      if (mounted) setState(() => _isWishlisted = !newState);
    }
  }

  Future<void> _joinEvent() async {
    if (_isJoining || _isJoined) return;
    setState(() => _isJoining = true);
    try {
      await EventService.joinEvent(widget.eventId);
      if (!mounted) return;
      setState(() => _isJoined = true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isJoining = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white.withAlpha(204),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        color: AppColors.primary,
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Event Details',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: AppColors.slate900,
          letterSpacing: -0.3,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            _isWishlisted ? Icons.favorite : Icons.favorite_border,
            color: _isWishlisted ? Colors.red : AppColors.slate500,
          ),
          onPressed: _event != null ? _toggleWishlist : null,
        ),
      ],
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _error!,
                style: const TextStyle(color: AppColors.slate500, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _loadEvent,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final event = _event!;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _EventHero(image: event.image),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tags
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: event.tags.asMap().entries.map((entry) {
                    final color = entry.key.isEven
                        ? AppColors.primary
                        : AppColors.secondary;
                    return TagChip(label: entry.value, color: color);
                  }).toList(),
                ),
                const SizedBox(height: 10),
                // Title
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: AppColors.slate900,
                    height: 1.15,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 24),
                // Info cards
                _EventInfoCard(
                  icon: Icons.location_on_outlined,
                  iconBg: AppColors.primary.withAlpha(26),
                  iconColor: AppColors.primary,
                  label: 'Location',
                  value: event.place,
                ),
                const SizedBox(height: 12),
                _EventInfoCard(
                  icon: Icons.schedule_outlined,
                  iconBg: AppColors.secondary.withAlpha(26),
                  iconColor: AppColors.secondary,
                  label: 'Time',
                  value: '${event.formattedDate} • ${event.formattedTime}',
                ),
                const SizedBox(height: 12),
                _ConductorCard(name: event.conductorName),
                const SizedBox(height: 24),
                // About section
                _AboutSection(description: event.description),
                const SizedBox(height: 24),
                // Join section (only for event type)
                if (event.type == 'event')
                  _JoinSection(
                    event: event,
                    isJoined: _isJoined,
                    isJoining: _isJoining,
                    onJoin: _joinEvent,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Hero Image ────────────────────────────────────────────────────────────────

class _EventHero extends StatelessWidget {
  final String? image;
  const _EventHero({this.image});

  @override
  Widget build(BuildContext context) {
    // Layout height is 272px; image extends to 320px via Stack clipBehavior.none
    // This creates a 48px visual overlap with the content below.
    return SizedBox(
      height: 272,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 320,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Image or placeholder
                  image != null && image!.isNotEmpty
                      ? Image.network(
                          image!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => _placeholder(),
                          loadingBuilder: (_, child, progress) =>
                              progress == null ? child : _placeholder(),
                        )
                      : _placeholder(),
                  // Gradient fade to background at bottom
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppColors.backgroundLight,
                          ],
                          stops: const [0.45, 1.0],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withAlpha(60),
              AppColors.secondary.withAlpha(40),
            ],
          ),
        ),
      );
}

// ─── Info Card ─────────────────────────────────────────────────────────────────

class _EventInfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String value;

  const _EventInfoCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white.withAlpha(204),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.slate100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.slate500,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.slate900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Conductor Card ─────────────────────────────────────────────────────────────

class _ConductorCard extends StatelessWidget {
  final String name;
  const _ConductorCard({required this.name});

  @override
  Widget build(BuildContext context) {
    final initials = name.trim().isEmpty
        ? '?'
        : name
            .trim()
            .split(RegExp(r'\s+'))
            .take(2)
            .map((w) => w[0].toUpperCase())
            .join();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white.withAlpha(204),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.slate100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(26),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.slate200),
            ),
            child: Center(
              child: Text(
                initials,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CONDUCTOR',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.slate500,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.slate900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── About Section ─────────────────────────────────────────────────────────────

class _AboutSection extends StatelessWidget {
  final String description;
  const _AboutSection({required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.slate100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About the Event',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.slate900,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description.isNotEmpty ? description : 'No description available.',
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.slate600,
              height: 1.65,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Join Section ──────────────────────────────────────────────────────────────

class _JoinSection extends StatelessWidget {
  final EventDetailModel event;
  final bool isJoined;
  final bool isJoining;
  final VoidCallback onJoin;

  const _JoinSection({
    required this.event,
    required this.isJoined,
    required this.isJoining,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    final avatarBgColors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.slate600,
    ];
    final visibleUsers = event.joinedUsers.take(3).toList();
    final extraCount =
        event.joinedCount > visibleUsers.length
            ? event.joinedCount - visibleUsers.length
            : 0;
    final totalSlots =
        visibleUsers.length + (extraCount > 0 ? 1 : 0);
    final stackWidth =
        totalSlots <= 0 ? 0.0 : 48.0 + (totalSlots - 1) * 32.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white.withAlpha(204),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.slate100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar stack
              if (event.joinedCount > 0 && visibleUsers.isNotEmpty) ...[
                SizedBox(
                  height: 48,
                  width: stackWidth,
                  child: Stack(
                    children: [
                      ...visibleUsers.asMap().entries.map((entry) {
                        final color =
                            avatarBgColors[entry.key % avatarBgColors.length];
                        final initials = entry.value.name.isNotEmpty
                            ? entry.value.name[0].toUpperCase()
                            : '?';
                        return Positioned(
                          left: entry.key * 32.0,
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: color.withAlpha(40),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.white,
                                width: 3,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                initials,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: color,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      if (extraCount > 0)
                        Positioned(
                          left: visibleUsers.length * 32.0,
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withAlpha(26),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.white,
                                width: 3,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '+$extraCount',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
              ],
              // Text info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${event.joinedCount} ${event.joinedCount == 1 ? 'person' : 'people'} joined',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.slate900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Be part of the community',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.slate500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // CTA button
          GestureDetector(
            onTap: isJoined || isJoining ? null : onJoin,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: isJoined ? AppColors.slate200 : AppColors.primary,
                borderRadius: BorderRadius.circular(999),
                boxShadow: isJoined
                    ? []
                    : [
                        BoxShadow(
                          color: AppColors.primary.withAlpha(77),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                      ],
              ),
              child: Center(
                child: isJoining
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: AppColors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        isJoined
                            ? 'Joined ✓'
                            : event.ctaText.toUpperCase(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: isJoined
                              ? AppColors.slate600
                              : AppColors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
