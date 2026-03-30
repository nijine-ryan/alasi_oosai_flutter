import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:alai_oosai/features/auth/data/village_model.dart';
import 'package:alai_oosai/core/constants/env_config.dart';

class VillageService {
  /// Fetches villages from the given endpoint.
  ///
  /// Expected response shape (example):
  /// {
  ///   "data": [ {"_id": "...", "name": "Idindhakarai"}, ... ],
  ///   "meta": {"count": 5},
  ///   "message": "Villages fetched successfully"
  /// }
  ///
  /// Returns a list of VillageModel. Throws an Exception with a readable
  /// message when the request fails or the response is unexpected.
  static Future<List<VillageModel>> fetchVillages({
    String url = '${EnvConfig.baseUrl}/villages',
  }) async {
    final uri = Uri.parse(url);
    final response = await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final body = json.decode(response.body);
      if (body is Map && body['data'] is List) {
        final List raw = body['data'] as List;
        return raw
            .whereType<Map<String, dynamic>>()
            .map((e) => VillageModel.fromJson(e))
            .toList();
      }
      throw Exception(body['message'] ?? 'Unexpected villages response');
    }

    // Non-2xx: try to parse message from body
    try {
      final body = json.decode(response.body);
      final msg = body is Map && body['message'] != null
          ? body['message']
          : response.reasonPhrase;
      throw Exception('Failed to fetch villages: $msg');
    } catch (error) {
      throw Exception('Failed to fetch villages: HTTP ${response.statusCode}');
    }
  }
}
