import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:alai_oosai/firebase_options.dart';
import 'package:alai_oosai/core/constants/env_config.dart';
import 'package:alai_oosai/features/auth/data/auth_service.dart';
import 'package:alai_oosai/features/announcement/presentation/announcement_screen.dart';
import 'package:alai_oosai/features/report/presentation/screens/reports_screen.dart';
import 'package:alai_oosai/main.dart' show navigatorKey;

// Top-level handler required by FCM for background/terminated state.
@pragma('vm:entry-point')
Future<void> _fcmBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // FCM shows the notification automatically when app is in background.
  // No extra action needed here unless you need to update local DB.
}

// Notification tap handler — navigates based on notification type payload.
@pragma('vm:entry-point')
void _onNotificationTapped(NotificationResponse response) {
  final payload = response.payload;
  if (payload == 'report') {
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => const ReportsScreen()),
    );
  } else {
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => const AnnouncementsScreen()),
    );
  }
}

class NotificationService {
  static bool _initialized = false;

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'alai_oosai_high_importance',
    'Alai Oosai Notifications',
    description: 'Village announcements and community notifications.',
    importance: Importance.high,
  );

  // ─── Bootstrap ──────────────────────────────────────────────────────────────

  static Future<void> initialize() async {
    // Local notifications work independently of Firebase — always set up first.
    await _setupLocalNotifications();
    // Request Android 13+ POST_NOTIFICATIONS permission without needing Firebase.
    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      FirebaseMessaging.onBackgroundMessage(_fcmBackgroundHandler);
      await _requestPermissions();
      // Listen for FCM messages when the app is in the foreground.
      FirebaseMessaging.onMessage.listen(_onForegroundMessage);
      _initialized = true;
    } catch (e) {
      // Firebase not configured yet — FCM features disabled.
      // Run `flutterfire configure` to enable push notifications.
      print('[NotificationService] Firebase not initialized: $e');
    }
  }

  // ─── Local Notification Setup ────────────────────────────────────────────────

  static Future<void> _setupLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _localNotifications.initialize(
      const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
    // Create Android O+ notification channel.
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  static Future<void> _requestPermissions() async {
    // iOS permission dialog (Android 13+ is handled separately in initialize()).
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('[NotificationService] Permission: ${settings.authorizationStatus}');
  }

  // ─── Foreground FCM Handler ──────────────────────────────────────────────────

  static Future<void> _onForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;
    final type = message.data['type'] as String?;
    await showLocalNotification(
      title: notification.title ?? 'Alai Oosai',
      body: notification.body ?? '',
      payload: type,
    );
  }

  // ─── Public: Show Local Notification ────────────────────────────────────────
  // Called by SocketService when an announcement:new event is received.

  static Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch.remainder(100000);
    await _localNotifications.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
    );
  }

  // ─── FCM Token Registration ──────────────────────────────────────────────────

  /// Call this after a successful login. Registers the device FCM token with
  /// the backend so the user receives push notifications.
  static Future<void> registerDeviceToken() async {
    if (!_initialized) return;
    final token = await FirebaseMessaging.instance.getToken();
    print("device token $token");
    if (token == null || AuthService.authToken == null) return;

    await _postToken(token);

    // Re-register if FCM rotates the token (e.g. app reinstall).
    FirebaseMessaging.instance.onTokenRefresh.listen(_postToken);
  }

  static Future<void> _postToken(String token) async {
    try {
      final uri = Uri.parse('${EnvConfig.baseUrl}/users/fcm-token');
      await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AuthService.authToken}',
        },
        body: jsonEncode({'token': token}),
      );
      print('[NotificationService] FCM token registered.');
    } catch (e) {
      print('[NotificationService] Token registration failed: $e');
    }
  }

  // ─── Topic Subscription ──────────────────────────────────────────────────────

  /// Subscribe to the village's FCM topic so broadcast push notifications
  /// are received even when the socket is disconnected.
  static Future<void> subscribeToVillage(String villageId) async {
    if (!_initialized) return;
    await FirebaseMessaging.instance.subscribeToTopic('village_$villageId');
    print('[NotificationService] Subscribed to village_$villageId');
  }

  static Future<void> unsubscribeFromVillage(String villageId) async {
    if (!_initialized) return;
    await FirebaseMessaging.instance.unsubscribeFromTopic('village_$villageId');
    print('[NotificationService] Unsubscribed from village_$villageId');
  }

  static Future<void> subscribeToReportTopic(String villageId) async {
    if (!_initialized) return;
    await FirebaseMessaging.instance.subscribeToTopic('report_village_$villageId');
    print('[NotificationService] Subscribed to report_village_$villageId');
  }

  static Future<void> unsubscribeFromReportTopic(String villageId) async {
    if (!_initialized) return;
    await FirebaseMessaging.instance.unsubscribeFromTopic('report_village_$villageId');
    print('[NotificationService] Unsubscribed from report_village_$villageId');
  }

  // ─── On Logout ───────────────────────────────────────────────────────────────

  /// Removes the FCM token from the backend on logout so no more pushes arrive.
  static Future<void> removeDeviceToken() async {
    if (!_initialized || AuthService.authToken == null) return;
    final token = await FirebaseMessaging.instance.getToken();
    if (token == null) return;
    try {
      final uri = Uri.parse('${EnvConfig.baseUrl}/users/fcm-token');
      await http.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AuthService.authToken}',
        },
        body: jsonEncode({'token': token}),
      );
    } catch (e) {
      print('[NotificationService] Token removal failed: $e');
    }
  }
}
