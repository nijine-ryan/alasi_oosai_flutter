import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:alai_oosai/core/constants/env_config.dart';
import 'package:alai_oosai/features/auth/data/auth_service.dart';
import 'announcement_model.dart';

class AnnouncementService {
  /// Fetches announcements for the authenticated user's village.
  /// Village context is derived from the JWT on the backend — no client param needed.
  static Future<List<AnnouncementModel>> fetchAnnouncements({
    int page = 1,
    int limit = 20,
  }) async {
    final uri = Uri.parse(
      '${EnvConfig.baseUrl}/announcements',
    ).replace(queryParameters: {'page': '$page', 'limit': '$limit'});

    final response = await http.get(uri, headers: {
      'Authorization': 'Bearer ${AuthService.authToken}',
    });

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 200 || body['success'] != true) {
      throw Exception(
        body['message']?.toString() ?? 'Failed to fetch announcements',
      );
    }

    final data = body['data'] as List<dynamic>;
    return data
        .map((item) => AnnouncementModel.fromApi(item as Map<String, dynamic>))
        .toList();
  }
}
