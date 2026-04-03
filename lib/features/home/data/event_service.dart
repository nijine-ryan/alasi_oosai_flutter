import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:alai_oosai/core/constants/env_config.dart';
import 'package:alai_oosai/features/auth/data/auth_service.dart';
import 'package:alai_oosai/features/home/data/event_detail_model.dart';
import 'package:alai_oosai/features/home/data/models.dart';

class EventService {
  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (AuthService.authToken != null)
          'Authorization': 'Bearer ${AuthService.authToken}',
      };

  static Future<List<EventModel>> fetchEvents({String? type, String? search}) async {
    final params = <String, String>{};
    if (type != null) params['type'] = type;
    if (search != null && search.isNotEmpty) params['search'] = search;
    final uri = Uri.parse('${EnvConfig.baseUrl}/events')
        .replace(queryParameters: params.isEmpty ? null : params);
    final response = await http.get(uri, headers: _headers);
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 200 || body['success'] != true) {
      throw Exception(body['message']?.toString() ?? 'Failed to load events');
    }
    final data = (body['data'] as List?) ?? [];
    return data
        .map((e) => EventModel.fromApi(e as Map<String, dynamic>))
        .toList();
  }

  static Future<EventDetailModel> fetchEventDetail(String id) async {
    final uri = Uri.parse('${EnvConfig.baseUrl}/events/$id');
    final response = await http.get(uri, headers: _headers);
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 200 || body['success'] != true) {
      throw Exception(body['message']?.toString() ?? 'Failed to load event');
    }
    return EventDetailModel.fromJson(body['data'] as Map<String, dynamic>);
  }

  static Future<void> joinEvent(String id) async {
    final uri = Uri.parse('${EnvConfig.baseUrl}/events/$id/join');
    final response = await http.post(uri, headers: _headers);
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 200 || body['success'] != true) {
      throw Exception(body['message']?.toString() ?? 'Failed to join event');
    }
  }

  static Future<void> addWishlist(String id) async {
    final uri = Uri.parse('${EnvConfig.baseUrl}/events/$id/wishlist');
    final response = await http.post(uri, headers: _headers);
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 200 || body['success'] != true) {
      throw Exception(body['message']?.toString() ?? 'Failed to add to wishlist');
    }
  }

  static Future<void> removeWishlist(String id) async {
    final uri = Uri.parse('${EnvConfig.baseUrl}/events/$id/wishlist');
    final response = await http.delete(uri, headers: _headers);
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 200 || body['success'] != true) {
      throw Exception(body['message']?.toString() ?? 'Failed to remove from wishlist');
    }
  }
}
