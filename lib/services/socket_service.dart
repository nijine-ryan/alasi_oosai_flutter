import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:alai_oosai/core/constants/env_config.dart';
import 'package:alai_oosai/features/auth/data/auth_service.dart';
import 'package:alai_oosai/services/notification_service.dart';

typedef AnnouncementCallback = void Function(Map<String, dynamic> data);
typedef NotificationCallback = void Function(Map<String, dynamic> data);
typedef ReportCallback = void Function(Map<String, dynamic> data);

/// Manages a single Socket.IO connection for the authenticated user.
///
/// Usage:
///   SocketService.connect();         // after login
///   SocketService.disconnect();      // on logout
///   SocketService.onAnnouncementNew(callback);  // subscribe
///   SocketService.offAnnouncementNew(callback); // unsubscribe
class SocketService {
  static io.Socket? _socket;
  static bool _connected = false;

  // Registered listeners — screens add/remove themselves via on/off methods.
  static final List<AnnouncementCallback> _announcementListeners = [];
  static final List<NotificationCallback> _notificationListeners = [];
  static final List<ReportCallback> _reportListeners = [];

  // ─── Connection ────────────────────────────────────────────────────────────

  static void connect() {
    final token = AuthService.authToken;
    if (token == null) {
      print('[SocketService] No auth token — connection skipped.');
      return;
    }

    _socket = io.io(
      EnvConfig.baseUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .enableAutoConnect()
          .enableReconnection()
          .setReconnectionDelay(2000)
          .setReconnectionAttempts(10)
          .build(),
    );

    _socket!.onConnect((_) {
      _connected = true;
      print('[SocketService] Connected to village room.');
    });

    _socket!.onDisconnect((_) {
      _connected = false;
      print('[SocketService] Disconnected.');
    });

    _socket!.onConnectError((err) {
      print('[SocketService] Connection error: $err');
    });

    // ── announcement:new ──────────────────────────────────────────────────────
    // Emitted by the server when a village admin creates an announcement.
    // Payload: { referenceId, title, message }
    _socket!.on('announcement:new', (raw) {
      final data = _toMap(raw);
      print('[SocketService] announcement:new → ${data['title']}');
      // Notify all registered screen listeners.
      for (final cb in List.of(_announcementListeners)) {
        cb(data);
      }
      // Show local notification so the user is alerted while the app is open.
      NotificationService.showLocalNotification(
        title: data['title']?.toString() ?? 'New Announcement',
        body: data['message']?.toString() ?? '',
        payload: 'announcement',
      );
    });

    // ── notification:new ──────────────────────────────────────────────────────
    // Emitted for every persisted notification (announcement, event, system).
    // Payload: { id, title, message, type, referenceId }
    _socket!.on('notification:new', (raw) {
      final data = _toMap(raw);
      print('[SocketService] notification:new → ${data['type']}');
      for (final cb in List.of(_notificationListeners)) {
        cb(data);
      }
    });

    // ── report:new ────────────────────────────────────────────────────────────
    // Emitted when a village admin uploads a new monthly report.
    // Payload: { referenceId, title, message }
    _socket!.on('report:new', (raw) {
      final data = _toMap(raw);
      print('[SocketService] report:new → ${data['title']}');
      for (final cb in List.of(_reportListeners)) {
        cb(data);
      }
      NotificationService.showLocalNotification(
        title: data['title']?.toString() ?? 'New Report',
        body: data['message']?.toString() ?? '',
        payload: 'report',
      );
    });

    _socket!.connect();
  }

  static void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _connected = false;
    _announcementListeners.clear();
    _notificationListeners.clear();
    _reportListeners.clear();
    print('[SocketService] Disconnected and cleaned up.');
  }

  // ─── Listener Registration ─────────────────────────────────────────────────

  static void onAnnouncementNew(AnnouncementCallback callback) {
    _announcementListeners.add(callback);
  }

  static void offAnnouncementNew(AnnouncementCallback callback) {
    _announcementListeners.remove(callback);
  }

  static void onNotificationNew(NotificationCallback callback) {
    _notificationListeners.add(callback);
  }

  static void offNotificationNew(NotificationCallback callback) {
    _notificationListeners.remove(callback);
  }

  static void onReportNew(ReportCallback callback) {
    _reportListeners.add(callback);
  }

  static void offReportNew(ReportCallback callback) {
    _reportListeners.remove(callback);
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  static bool get isConnected => _connected;

  static Map<String, dynamic> _toMap(dynamic raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return {};
  }
}
