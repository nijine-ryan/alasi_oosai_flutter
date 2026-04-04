import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:alai_oosai/core/constants/env_config.dart';

class AuthService {
  static String? authToken;
  static String? userName;
  /// The village_id extracted from the JWT. Populated after a successful login.
  static String? villageId;

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
    print(
      'OTP send response: ${response.statusCode} - ${response.body}',
    ); // Debug print
    if (response.statusCode != 200) {
      final body = jsonDecode(response.body);
      throw Exception(body['message']?.toString() ?? 'Failed to send OTP');
    }
    // Optionally handle response body if needed
  }

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
        final decoded = jsonDecode(utf8.decode(base64Url.decode(padded))) as Map<String, dynamic>;
        userName = decoded['name'] as String?;
        villageId = decoded['village_id'] as String?;
      }
    }
  }
}
