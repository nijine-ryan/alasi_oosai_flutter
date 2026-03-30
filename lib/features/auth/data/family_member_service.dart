import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:alai_oosai/core/constants/env_config.dart';
import 'family_member_model.dart';

class FamilyMemberService {
  static Future<List<FamilyMemberModel>> fetchMembers({
    required String familyId,
    required String villageId,
  }) async {
    print(
      'Fetching members for family ID: $familyId and village ID: $villageId',
    );
    final uri = Uri.parse(
      '${EnvConfig.baseUrl}/family-card/$familyId/members?village_id=$villageId',
    );
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final List data = body['data'];
      print('Fetched members data: $data'); // Debug print
      return data.map((e) => FamilyMemberModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load members');
    }
  }
}
