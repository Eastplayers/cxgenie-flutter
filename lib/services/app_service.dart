import 'dart:convert';
import 'package:cxgenie/models/bot.dart';
import 'package:cxgenie/models/customer.dart';
import 'package:cxgenie/models/message.dart';
import 'package:cxgenie/models/ticket.dart';
import 'package:cxgenie/models/ticket_category.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AppService {
  final baseUrl = 'https://api.cxgenie.ai/api/v1';

  Future<Bot> getBotDetail(String id) async {
    try {
      final url = '$baseUrl/bots/public/$id';
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final data = json['data'];
        return Bot.fromJson(data);
      }

      final json = jsonDecode(response.body);
      throw Exception(json['error']['message']);
    } catch (e) {
      rethrow;
    }
  }

  Future<Customer> startSession(String botId, String name, String email) async {
    try {
      final url = '$baseUrl/bot-sessions/start-bot-session';
      final uri = Uri.parse(url);
      final response = await http.post(uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(
              <String, String>{'bot_id': botId, 'name': name, 'email': email}));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final data = json['data'];
        return Customer.fromJson(data);
      }

      final json = jsonDecode(response.body);
      throw Exception(json['error']['message']);
    } catch (e) {
      rethrow;
    }
  }

  Future<Customer?> startAuthorizedSession(String botId, String token) async {
    try {
      final url = '$baseUrl/bot-sessions/start-bot-session';
      final uri = Uri.parse(url);
      final response = await http.post(uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(
              <String, String>{'bot_id': botId, 'customer_auth_token': token}));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final data = json['data'];
        if (data != null) {
          return Customer.fromJson(data);
        }

        return null;
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendMessage(String virtualAgentId, String senderId,
      String content, List<MessageMedia>? media) async {
    try {
      final url = '$baseUrl/messages/bot';
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

      if (response.statusCode != 200) {
        final json = jsonDecode(response.body);
        throw Exception(json['error']['message']);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Message>> getMessages(String customerId) async {
    try {
      final url =
          '$baseUrl/messages/customer?limit=1000&offset=0&order=desc&customer_id=$customerId';
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
          final bot = message['bot'];
          final sender = message['sender'];
          final receiver = message['receiver'];
          final media =
              message['media'] == null ? null : message['media'] as List;

          return Message(
              id: message['id'],
              content: message['content'],
              receiverId: message['receiver_id'],
              type: message['type'],
              botId: message['bot_id'],
              senderId: message['sender_id'],
              createdAt: message['created_at'],
              media: media == null
                  ? []
                  : media.map((mediaItem) {
                      return MessageMedia(url: mediaItem['url']);
                    }).toList(),
              bot: bot == null ? null : Bot.fromJson(bot),
              sender: sender == null ? null : Customer.fromJson(sender),
              receiver: receiver == null ? null : Customer.fromJson(receiver));
        }).toList();

        return messages;
      }

      final json = jsonDecode(response.body);
      throw Exception(json['error']['message']);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Ticket>> getTickets(
      String customerId, String workspaceId, List<String> statuses) async {
    try {
      // final url =
      //     '$baseUrl/tickets/public?creator_id=$customerId&workspace_id=$workspaceId';
      // final uri = Uri.parse(url);
      final uri = Uri(
          scheme: 'https',
          host: 'api.cxgenie.ai',
          path: '/api/v1/tickets/public',
          queryParameters: {
            'creator_id': customerId,
            'workspace_id': workspaceId,
            'status[]': statuses
          });

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
          return Ticket.fromJson(ticket);
        }).toList();

        return tickets;
      }

      final json = jsonDecode(response.body);
      throw Exception(json['error']['message']);
    } catch (e) {
      rethrow;
    }
  }

  Future<Ticket> getTicketDetail(String ticketId) async {
    try {
      print(ticketId);
      final url = '$baseUrl/tickets/$ticketId/public';
      print(url);
      final uri = Uri.parse(url);

      final response = await http.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final data = json['data'];
        return Ticket.fromJson(data);
      }

      final json = jsonDecode(response.body);
      throw Exception(json['error']['message']);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TicketCategory>> getTicketCategories(String workspaceId) async {
    try {
      final uri = Uri(
          scheme: 'https',
          host: 'api.cxgenie.ai',
          path: '/api/v1/ticket-categories',
          queryParameters: {
            'limit': '100',
            'offset': '0',
            'workspace_id': workspaceId
          });
      final response = await http.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final data = json['data']['ticketCategories'] as List;
        final categories = data.map((category) {
          return TicketCategory.fromJson(category);
        }).toList();

        return categories;
      }

      final json = jsonDecode(response.body);
      throw Exception(json['error']['message']);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TicketCategory>> getTicketSubCategories(
      String workspaceId, String parentId) async {
    try {
      final uri = Uri(
          scheme: 'https',
          host: 'api.cxgenie.ai',
          path: '/api/v1/ticket-categories',
          queryParameters: {
            'limit': '100',
            'offset': '0',
            'workspace_id': workspaceId,
            'parent_id': parentId
          });
      final response = await http.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final data = json['data']['ticketCategories'] as List;
        final categories = data.map((category) {
          return TicketCategory.fromJson(category);
        }).toList();

        return categories;
      }

      final json = jsonDecode(response.body);
      throw Exception(json['error']['message']);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Message>> getTicketMessages(String ticketId) async {
    try {
      final url =
          '$baseUrl/messages/ticket?limit=1000&offset=0&order=desc&ticket_id=$ticketId';
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
          final bot = message['bot'];
          final sender = message['sender'];
          final receiver = message['receiver'];
          final media =
              message['media'] == null ? null : message['media'] as List;

          return Message(
              id: message['id'],
              content: message['content'],
              receiverId: message['receiver_id'],
              type: message['type'],
              botId: message['bot_id'],
              senderId: message['sender_id'],
              createdAt: message['created_at'],
              media: media == null
                  ? []
                  : media.map((mediaItem) {
                      return MessageMedia(url: mediaItem['url']);
                    }).toList(),
              bot: bot == null ? null : Bot.fromJson(bot),
              sender: sender == null ? null : Customer.fromJson(sender),
              receiver: receiver == null ? null : Customer.fromJson(receiver));
        }).toList();

        return messages;
      }

      final json = jsonDecode(response.body);
      throw Exception(json['error']['message']);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendTicketMessage(String workspaceId, String ticketId,
      String senderId, String content, List<MessageMedia>? media) async {
    try {
      final url = '$baseUrl/messages/ticket';
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

      if (response.statusCode != 200) {
        final json = jsonDecode(response.body);
        throw Exception(json['error']['message']);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createTicket(String workspaceId, String content,
      String customerId, String? categoryId) async {
    try {
      final url = '$baseUrl/tickets';
      final uri = Uri.parse(url);
      final response = await http.post(uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, dynamic>{
            'content': content,
            'workspace_id': workspaceId,
            'customer_id': customerId,
            'ticket_category_id': categoryId!.isNotEmpty ? categoryId : null
          }));

      if (response.statusCode != 200) {
        final json = jsonDecode(response.body);
        throw Exception(json['error']['message']);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Customer> getCustomerDetail(String id) async {
    try {
      final url = '$baseUrl/customers/$id/public';
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final data = json['data'];
        return Customer.fromJson(data);
      }

      final json = jsonDecode(response.body);
      throw Exception(json['error']['message']);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>> uploadFiles(List<XFile> files) async {
    final url = '$baseUrl/files/multiple-upload';
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

    final json = jsonDecode(response.body);
    throw Exception(json['error']['message']);
  }

  Future<String> uploadFile(XFile xFile) async {
    try {
      final url = '$baseUrl/files/upload';
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

      final json = jsonDecode(response.body);
      throw Exception(json['error']['message']);
    } catch (e) {
      rethrow;
    }
  }
}
