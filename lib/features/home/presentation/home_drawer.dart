import 'package:alai_oosai/core/constants/app_constants.dart';
import 'package:alai_oosai/features/auth/data/auth_service.dart';
import 'package:alai_oosai/features/auth/presentation/screens/login/login_send_otp_screen.dart';
import 'package:alai_oosai/features/profile/presentation/profile_screen.dart';
import 'package:alai_oosai/features/settings/presentation/settings_screen.dart';
import 'package:flutter/material.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  void _navigate(BuildContext context, Widget screen) {
    Navigator.pop(context); // close drawer
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  void _logout(BuildContext context) {
    Navigator.pop(context); // close drawer
    AuthService.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginSendOtpScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = AuthService.userName ?? 'Village Member';
    final cs = Theme.of(context).colorScheme;
    return Drawer(
      backgroundColor: cs.surface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: cs.outlineVariant),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(26),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : '?',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Village Member',
                    style: TextStyle(
                      fontSize: 12,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Menu items
            _DrawerItem(
              icon: Icons.person_outline,
              label: 'Profile',
              onTap: () => _navigate(context, const ProfileScreen()),
            ),
            _DrawerItem(
              icon: Icons.settings_outlined,
              label: 'Settings',
              onTap: () => _navigate(context, const SettingsScreen()),
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(),
            ),
            _DrawerItem(
              icon: Icons.logout,
              label: 'Logout',
              color: Colors.red.shade600,
              onTap: () => _logout(context),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final itemColor = color ?? cs.onSurface;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: color != null
                    ? color!.withAlpha(20)
                    : cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: itemColor),
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: itemColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
