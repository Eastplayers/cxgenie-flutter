import 'dart:convert';
import 'package:cxgenie/models/customer.dart';
import 'package:cxgenie/models/message.dart';
import 'package:cxgenie/models/virtual_agent.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

class ChatService {
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
        themeColor:
            data['theme_color'] == null ? '#364DE7' : data['theme_color'],
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

  Future<void> sendMessage(String virtualAgentId, String senderId,
      String content, List<String>? media) async {
    final url = '$baseUrl/api/v1/chat-logs/chatbot';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          'sender_id': senderId,
          'content': content,
          'chat_user_id': senderId,
          'chatbot_id': virtualAgentId,
          'media': media
        }));
  }

  Future<List<Message>> getMessages(String customerId) async {
    final url =
        '$baseUrl/api/v1/chat-logs/customer?limit=1000&offset=0&order=desc&chat_user_id=$customerId';
    final uri = Uri.parse(url);
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final data = json['data']['chat_logs'] as List;
      final messages = data.map((message) {
        final virtualAgent = message['chatbot'];
        final sender = message['sender'];
        final receiver = message['receiver'];
        return Message(
            id: message['id'],
            content: message['content'],
            receiverId: message['receiver_id'],
            type: message['type'],
            virtualAgentId: message['chatbot_id'],
            senderId: message['sender_id'],
            createdAt: message['created_at'],
            virtualAgent: virtualAgent == null
                ? null
                : VirtualAgent(
                    id: virtualAgent['id'],
                    name: virtualAgent['name'],
                    themeColor: virtualAgent['theme_color'],
                    createdAt: virtualAgent['created_at'],
                    updatedAt: virtualAgent['updated_at'],
                    workspaceId: virtualAgent['workspace_id'],
                  ),
            sender: sender == null
                ? null
                : Customer(
                    id: sender['id'],
                    name: sender['name'],
                    avatar: sender['avatar']),
            receiver: receiver == null
                ? null
                : Customer(
                    id: receiver['id'],
                    name: receiver['name'],
                    avatar: receiver['avatar']));
      }).toList();

      developer.log(customerId, name: "${response.statusCode}", error: data);

      return messages;
    }

    throw "Cannot start session";
  }
}
