import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:alai_oosai/core/constants/env_config.dart';

class AuthService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const _keyToken = 'auth_token';
  static const _keyUserName = 'auth_user_name';
  static const _keyUserId = 'auth_user_id';
  static const _keyVillageId = 'auth_village_id';

  // ─── In-memory session (populated from storage on startup) ───────────────
  static String? authToken;
  static String? userName;
  static String? userId;
  static String? villageId;

  // ─── Startup restore ──────────────────────────────────────────────────────
  /// Call once at app startup. Returns true if a valid session was restored.
  static Future<bool> tryRestoreSession() async {
    final token = await _storage.read(key: _keyToken);
    if (token == null) return false;
    authToken = token;
    userName = await _storage.read(key: _keyUserName);
    userId = await _storage.read(key: _keyUserId);
    villageId = await _storage.read(key: _keyVillageId);
    return true;
  }

  // ─── Logout ───────────────────────────────────────────────────────────────
  static Future<void> logout() async {
    authToken = null;
    userName = null;
    userId = null;
    villageId = null;
    await _storage.deleteAll();
  }

  // ─── OTP registration flow ────────────────────────────────────────────────
  static Future<void> sendOtp({
    required String phoneNumber,
    required String familyCard,
    required String villageId,
    required String userId,
  }) async {
    final uri = Uri.parse('${EnvConfig.baseUrl}/auth/register-send-otp');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'phone_number': phoneNumber,
        'family_card_number': familyCard,
        'village_id': villageId,
        'user_id': userId,
      }),
    );
    print('OTP send response: ${response.statusCode} - ${response.body}');
    if (response.statusCode != 200) {
      final body = jsonDecode(response.body);
      throw Exception(body['message']?.toString() ?? 'Failed to send OTP');
    }
  }

  // ─── Login flow ───────────────────────────────────────────────────────────
  static Future<void> sendLoginOtp({required String phoneNumber}) async {
    final uri = Uri.parse('${EnvConfig.baseUrl}/auth/send-otp');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone_number': phoneNumber}),
    );
    print('Login OTP send response: ${response.statusCode} - ${response.body}');
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 200 || body['success'] != true) {
      throw Exception(body['message']?.toString() ?? 'Failed to send OTP');
    }
  }

  static Future<void> verifyLoginOtp({
    required String phoneNumber,
    required int otp,
  }) async {
    final uri = Uri.parse('${EnvConfig.baseUrl}/auth/verify-otp');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone_number': phoneNumber, 'otp': otp}),
    );
    print('Verify OTP response: ${response.statusCode} - ${response.body}');
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 200 || body['success'] != true) {
      throw Exception(body['message']?.toString() ?? 'Invalid OTP');
    }

    authToken = body['data']['token'] as String?;
    if (authToken != null) {
      final parts = authToken!.split('.');
      if (parts.length == 3) {
        final padded = base64Url.normalize(parts[1]);
        final decoded =
            jsonDecode(utf8.decode(base64Url.decode(padded))) as Map<String, dynamic>;
        userName = decoded['name'] as String?;
        villageId = decoded['village_id'] as String?;
        userId = decoded['sub'] as String?;
      }

      // Persist session to device secure storage.
      await _storage.write(key: _keyToken, value: authToken);
      if (userName != null) await _storage.write(key: _keyUserName, value: userName);
      if (userId != null) await _storage.write(key: _keyUserId, value: userId);
      if (villageId != null) await _storage.write(key: _keyVillageId, value: villageId);
    }
  }
}
