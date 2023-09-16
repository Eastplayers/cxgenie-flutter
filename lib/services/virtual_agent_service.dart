import 'dart:convert';
import 'package:cxgenie/models/virtual_agent.dart';
import 'package:http/http.dart' as http;

class VirtualAgentService {
  Future<VirtualAgent> getDetail(String id) async {
    final url = 'https://api-staging.cxgenie.ai/api/v1/chatbots/public/$id';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final data = json['data'];
      return VirtualAgent(
        id: data['id'],
        name: data['name'],
        themeColor: data['theme_color'],
        createdAt: data['created_at'],
        updatedAt: data['updated_at'],
        workspaceId: data['workspace_id'],
      );
    }

    throw "Virtual agent not found";
  }
}
