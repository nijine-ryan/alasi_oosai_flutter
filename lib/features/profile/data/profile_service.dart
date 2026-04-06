import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:alai_oosai/core/constants/env_config.dart';
import 'package:alai_oosai/features/auth/data/auth_service.dart';

class UserProfile {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String role;

  const UserProfile({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    required this.role,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String?,
      role: json['role'] as String? ?? 'user',
    );
  }
}

class ProfileService {
  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AuthService.authToken ?? ''}',
      };

  static Future<UserProfile> fetchProfile() async {
    final id = AuthService.userId;
    if (id == null || id.isEmpty) throw Exception('User ID not available');
    final uri = Uri.parse('${EnvConfig.baseUrl}/users/$id');
    final response = await http.get(uri, headers: _headers);
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 200) {
      throw Exception(body['message']?.toString() ?? 'Failed to fetch profile');
    }
    final data = body['data'] as Map<String, dynamic>? ?? body;
    return UserProfile.fromJson(data);
  }

  static Future<UserProfile> updateProfile({
    required String name,
    String? email,
  }) async {
    final id = AuthService.userId;
    if (id == null || id.isEmpty) throw Exception('User ID not available');
    final uri = Uri.parse('${EnvConfig.baseUrl}/users/$id');
    final payload = <String, dynamic>{'name': name};
    if (email != null && email.isNotEmpty) payload['email'] = email;
    final response = await http.patch(
      uri,
      headers: _headers,
      body: jsonEncode(payload),
    );
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 200) {
      throw Exception(body['message']?.toString() ?? 'Failed to update profile');
    }
    final data = body['data'] as Map<String, dynamic>? ?? body;
    return UserProfile.fromJson(data);
  }
}
