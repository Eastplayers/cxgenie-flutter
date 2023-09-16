import 'dart:convert';
import 'package:cxgenie/models/customer.dart';
import 'package:cxgenie/models/virtual_agent.dart';
import 'package:http/http.dart' as http;

class VirtualAgentService {
  final baseUrl = 'https://api-staging.cxgenie.ai';

  Future<VirtualAgent> getDetail(String id) async {
    final url = '$baseUrl/api/v1/chatbots/public/$id';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final data = json['data'];
      return VirtualAgent(
        id: data['id'],
        name: data['name'],
        avatar: data['avatar'],
        themeColor: data['theme_color'],
        createdAt: data['created_at'],
        updatedAt: data['updated_at'],
        workspaceId: data['workspace_id'],
      );
    }

    throw "Virtual agent not found";
  }

  Future<Customer> startSession(
      String virtualAgentId, String name, String email) async {
    final url = '$baseUrl/api/v1/chat-sessions/start-chatbot-session';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'chatbot_id': virtualAgentId,
          'name': name,
          'email': email
        }));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final data = json['data'];
      return Customer(
        id: data['id'],
        name: data['name'],
        avatar: data['avatar'],
      );
    }

    throw "Cannot start session";
  }
}
