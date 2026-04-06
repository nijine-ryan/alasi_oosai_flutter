import 'package:flutter/material.dart';
import 'package:alai_oosai/core/constants/app_constants.dart';
import 'package:alai_oosai/core/theme/theme_notifier.dart';
import 'package:alai_oosai/features/auth/data/auth_service.dart';
import 'package:alai_oosai/features/auth/presentation/screens/login/login_send_otp_screen.dart';
import 'package:alai_oosai/features/announcement/presentation/announcement_screen.dart';
import 'package:alai_oosai/features/home/presentation/home_page.dart';
import 'package:alai_oosai/features/report/presentation/screens/reports_screen.dart';
import 'package:alai_oosai/services/notification_service.dart';
import 'package:alai_oosai/services/socket_service.dart';

/// Global navigator key — allows non-widget code (e.g. NotificationService)
/// to push routes without a BuildContext.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase and local notifications.
  // Gracefully no-ops if firebase_options.dart has not been configured yet.
  await NotificationService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: appThemeMode,
      builder: (context, mode, child) => MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Alai Oosai',
        debugShowCheckedModeBanner: false,
        themeMode: mode,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          fontFamily: 'Roboto',
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            brightness: Brightness.dark,
          ),
          fontFamily: 'Roboto',
          useMaterial3: true,
        ),
        home: const _AppRoot(),
      ),
    );
  }
}

/// Resolves the initial route by checking for a persisted session.
/// Shows a neutral splash while the async check runs, then replaces itself.
class _AppRoot extends StatefulWidget {
  const _AppRoot();

  @override
  State<_AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<_AppRoot> {
  @override
  void initState() {
    super.initState();
    _resolve();
  }

  Future<void> _resolve() async {
    final restored = await AuthService.tryRestoreSession();
    if (!mounted) return;

    if (restored) {
      // Re-connect real-time services so the session is fully live.
      if (AuthService.villageId != null) {
        NotificationService.registerDeviceToken();
        NotificationService.subscribeToVillage(AuthService.villageId!);
        NotificationService.subscribeToReportTopic(AuthService.villageId!);
      }
      SocketService.connect();
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) =>
            restored ? const MainNavigationPage() : const LoginSendOtpScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Minimal splash shown for the fraction of a second during the storage read.
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

// ─── Main app shell (reached only after auth) ─────────────────────────────────

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  late final PageController _pageController = PageController();

  void _onPageChanged(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [HomePage(), AnnouncementsScreen(), ReportsScreen()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onPageChanged,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(
            icon: Icon(Icons.campaign),
            label: 'Announcement',
          ),
          NavigationDestination(icon: Icon(Icons.article), label: 'Report'),
        ],
      ),
    );
  }
}
