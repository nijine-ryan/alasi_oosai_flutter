import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:alai_oosai/core/constants/env_config.dart';

class AuthService {
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
        'family_card': familyCard,
        'village_id': villageId,
        'user_id': userId,
      }),
    );
    print(
      'OTP send response: ${response.statusCode} - ${response.body}',
    ); // Debug print
    if (response.statusCode != 200) {
      throw Exception('Failed to send OTP');
    }
    // Optionally handle response body if needed
  }
}
