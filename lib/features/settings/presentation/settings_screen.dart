import 'package:flutter/material.dart';
import 'package:alai_oosai/core/constants/app_constants.dart';
import 'package:alai_oosai/core/theme/theme_notifier.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _announcementAlerts = true;
  bool _eventReminders = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ValueListenableBuilder<ThemeMode>(
        valueListenable: appThemeMode,
        builder: (context, mode, child) {
          final isDark = mode == ThemeMode.dark;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _SectionHeader(title: 'Appearance'),
              _SettingsCard(
                children: [
                  _SwitchTile(
                    icon: isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                    title: 'Dark Mode',
                    subtitle: isDark ? 'Switch to light theme' : 'Switch to dark theme',
                    value: isDark,
                    onChanged: (v) {
                      appThemeMode.value =
                          v ? ThemeMode.dark : ThemeMode.light;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _SectionHeader(title: 'Notifications'),
              _SettingsCard(
                children: [
                  _SwitchTile(
                    icon: Icons.notifications_outlined,
                    title: 'Push Notifications',
                    subtitle: 'Receive alerts on your device',
                    value: _notificationsEnabled,
                    onChanged: (v) =>
                        setState(() => _notificationsEnabled = v),
                  ),
                  const _Divider(),
                  _SwitchTile(
                    icon: Icons.campaign_outlined,
                    title: 'Announcements',
                    subtitle: 'New village announcements',
                    value: _announcementAlerts,
                    onChanged: _notificationsEnabled
                        ? (v) => setState(() => _announcementAlerts = v)
                        : null,
                  ),
                  const _Divider(),
                  _SwitchTile(
                    icon: Icons.event_outlined,
                    title: 'Event Reminders',
                    subtitle: 'Upcoming event notifications',
                    value: _eventReminders,
                    onChanged: _notificationsEnabled
                        ? (v) => setState(() => _eventReminders = v)
                        : null,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _SectionHeader(title: 'Privacy'),
              _SettingsCard(
                children: [
                  _NavTile(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    onTap: () {},
                  ),
                  const _Divider(),
                  _NavTile(
                    icon: Icons.description_outlined,
                    title: 'Terms of Service',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _SectionHeader(title: 'About'),
              _SettingsCard(
                children: [
                  _NavTile(
                    icon: Icons.info_outline,
                    title: 'App Version',
                    trailing: const Text(
                      '1.0.0',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.slate400,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: null,
                  ),
                  const _Divider(),
                  _NavTile(
                    icon: Icons.support_agent_outlined,
                    title: 'Contact Support',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.outline,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

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
            color: Colors.black.withAlpha(8),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: cs.onSurfaceVariant),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: onChanged != null ? cs.onSurface : cs.outline,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primary,
            activeTrackColor: AppColors.primary.withAlpha(100),
          ),
        ],
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _NavTile({
    required this.icon,
    required this.title,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: cs.onSurfaceVariant),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
              ),
            ),
            trailing ??
                (onTap != null
                    ? Icon(
                        Icons.chevron_right,
                        color: cs.outline,
                        size: 20,
                      )
                    : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, indent: 52, endIndent: 0);
  }
}
