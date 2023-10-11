import 'dart:convert';
import 'package:cxgenie/models/customer.dart';
import 'package:cxgenie/models/message.dart';
import 'package:cxgenie/models/ticket.dart';
import 'package:cxgenie/models/virtual_agent.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ChatService {
  final baseUrl = 'https://api.cxgenie.ai';

  Future<VirtualAgent> getDetail(String id) async {
    final url = '$baseUrl/api/v1/bots/public/$id';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final data = json['data'];
      return VirtualAgent(
        id: data['id'],
        name: data['name'],
        avatar: data['avatar'],
        themeColor: data['theme_color'] ?? '#364DE7',
        createdAt: data['created_at'],
        updatedAt: data['updated_at'],
        workspaceId: data['workspace_id'],
        workspaceRequiredLogin: data['workspace_required_login'],
        isTicketEnable: data['is_ticket_enable'],
      );
    }

    throw "Virtual agent not found";
  }

  Future<Customer> startSession(
      String virtualAgentId, String name, String email) async {
    final url = '$baseUrl/api/v1/chat-sessions/start-bot-session';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'bot_id': virtualAgentId,
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

  Future<Customer> startAuthorizedSession(
      String virtualAgentId, String token) async {
    final url = '$baseUrl/api/v1/chat-sessions/start-bot-session';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'bot_id': virtualAgentId,
          'customer_auth_token': token
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
      String content, List<MessageMedia>? media) async {
    final url = '$baseUrl/api/v1/messages/bot';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          'sender_id': senderId,
          'content': content,
          'customer_id': senderId,
          'bot_id': virtualAgentId,
          'media': media
        }));
  }

  Future<List<Message>> getMessages(String customerId) async {
    final url =
        '$baseUrl/api/v1/messages/customer?limit=1000&offset=0&order=desc&customer_id=$customerId';
    final uri = Uri.parse(url);
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final data = json['data']['messages'] as List;
      final messages = data.map((message) {
        final virtualAgent = message['bot'];
        final sender = message['sender'];
        final receiver = message['receiver'];
        final media =
            message['media'] == null ? null : message['media'] as List;

        return Message(
            id: message['id'],
            content: message['content'],
            receiverId: message['receiver_id'],
            type: message['type'],
            virtualAgentId: message['bot_id'],
            senderId: message['sender_id'],
            createdAt: message['created_at'],
            media: media == null
                ? []
                : media.map((mediaItem) {
                    return MessageMedia(url: mediaItem['url']);
                  }).toList(),
            virtualAgent: virtualAgent == null
                ? null
                : VirtualAgent(
                    id: virtualAgent['id'],
                    name: virtualAgent['name'],
                    themeColor: virtualAgent['theme_color'] ?? '#364DE7',
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

      return messages;
    }

    throw "Cannot get message";
  }

  Future<List<Ticket>> getTickets(String customerId, String workspaceId) async {
    final url =
        '$baseUrl/api/v1/tickets/public?creator_id=$customerId&workspace_id=$workspaceId';
    final uri = Uri.parse(url);
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final data = json['data']['tickets'] as List;
      final tickets = data.map((ticket) {
        final assignee = ticket['assignee'];

        return Ticket(
            id: ticket['id'],
            name: ticket['name'],
            status: ticket['status'],
            code: ticket['code'],
            createdAt: ticket['created_at'],
            updatedAt: ticket['updated_at'],
            creatorId: ticket['creator_id'],
            assignee: assignee == null
                ? null
                : Customer(id: assignee['id'], name: assignee['name']));
      }).toList();

      return tickets;
    }

    throw "Cannot get tickets";
  }

  Future<List<Message>> getTicketMessages(String ticketId) async {
    final url =
        '$baseUrl/api/v1/messages/ticket?limit=1000&offset=0&order=desc&ticket_id=$ticketId';
    final uri = Uri.parse(url);
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final data = json['data']['messages'] as List;
      final messages = data.map((message) {
        final virtualAgent = message['bot'];
        final sender = message['sender'];
        final receiver = message['receiver'];
        final media =
            message['media'] == null ? null : message['media'] as List;

        return Message(
            id: message['id'],
            content: message['content'],
            receiverId: message['receiver_id'],
            type: message['type'],
            virtualAgentId: message['bot_id'],
            senderId: message['sender_id'],
            createdAt: message['created_at'],
            media: media == null
                ? []
                : media.map((mediaItem) {
                    return MessageMedia(url: mediaItem['url']);
                  }).toList(),
            virtualAgent: virtualAgent == null
                ? null
                : VirtualAgent(
                    id: virtualAgent['id'],
                    name: virtualAgent['name'],
                    themeColor: virtualAgent['theme_color'] ?? '#364DE7',
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

      return messages;
    }

    throw "Cannot get ticket messages";
  }

  Future<void> sendTicketMessage(String workspaceId, String ticketId,
      String senderId, String content, List<MessageMedia>? media) async {
    final url = '$baseUrl/api/v1/messages/ticket';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          'sender_id': senderId,
          'content': content,
          'customer_id': senderId,
          'workspace_id': workspaceId,
          'media': media,
          'ticket_id': ticketId
        }));
  }

  Future<void> createTicket(
      String workspaceId, String name, String email, String content) async {
    final url = '$baseUrl/api/v1/tickets';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          'name': name,
          'content': content,
          'email': email,
          'workspace_id': workspaceId,
        }));
  }

  Future<Customer> getCustomerDetail(String id) async {
    final url = '$baseUrl/api/v1/customers/$id/public';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final data = json['data'];
      return Customer(
        id: data['id'],
        name: data['name'],
        avatar: data['avatar'],
        email: data['email'],
      );
    }

    throw "Customer not found";
  }

  Future<List<String>> uploadFiles(List<XFile> files) async {
    final url = '$baseUrl/api/v1/files/multiple-upload';
    final uri = Uri.parse(url);
    var request = http.MultipartRequest("POST", uri);

    for (var i = 0; i < files.length; i++) {
      var file = await http.MultipartFile.fromPath('files', files[i].path);
      request.files.add(file);
    }

    var streamResponse = await request.send();
    var response = await http.Response.fromStream(streamResponse);
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);

      return json['urls'] as List<String>;
    }

    throw 'Cannot upload files';
  }

  Future<String> uploadFile(XFile xFile) async {
    final url = '$baseUrl/api/v1/files/upload';
    final uri = Uri.parse(url);
    var request = http.MultipartRequest("POST", uri);
    var file = await http.MultipartFile.fromPath('file', xFile.path);
    request.files.add(file);

    var streamResponse = await request.send();
    var response = await http.Response.fromStream(streamResponse);
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return json['url'];
    }

    throw 'Cannot uploda file';
  }
}
