import 'dart:convert';
import 'package:alai_oosai/core/constants/env_config.dart';
import 'package:http/http.dart' as http;

class FamilyRegistrationService {
  static Future<FamilyRegistrationResult> verifyFamilyCard({
    required String villageId,
    required String familyCardNumber,
    String url = '${EnvConfig.baseUrl}/family-card/verify',
  }) async {
    final uri = Uri.parse(url);
    final response = await http
        .post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'village_id': villageId,
            'family_card_number': familyCardNumber,
          }),
        )
        .timeout(const Duration(seconds: 10));

    final body = json.decode(response.body);
    if (response.statusCode >= 200 &&
        response.statusCode < 300 &&
        body['success'] == true) {
      return FamilyRegistrationResult.success(
        id: body['_id']?.toString(),
        message: body['message']?.toString() ?? 'OK',
      );
    }
    // Validation or other error
    if (body is Map && body['error'] is Map) {
      final error = body['error'] as Map;
      final fields = error['fields'] is Map ? error['fields'] as Map : null;
      return FamilyRegistrationResult.failure(
        message: error['message']?.toString() ?? 'Validation failed',
        fieldErrors: fields?.map(
          (k, v) => MapEntry(
            k.toString(),
            (v as List).map((e) => e.toString()).toList(),
          ),
        ),
      );
    }
    // Fallback error
    return FamilyRegistrationResult.failure(
      message: body['message']?.toString() ?? 'Unknown error',
    );
  }
}

class FamilyRegistrationResult {
  final bool success;
  final String? id;
  final String message;
  final Map<String, List<String>>? fieldErrors;

  FamilyRegistrationResult.success({this.id, required this.message})
    : success = true,
      fieldErrors = null;
  FamilyRegistrationResult.failure({required this.message, this.fieldErrors})
    : success = false,
      id = null;
}
