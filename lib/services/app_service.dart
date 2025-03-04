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
      if (response.statusCode < 300) {
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
      final url = '$baseUrl/bot-sessions/guest-auth/start-bot-session';
      final uri = Uri.parse(url);
      final response = await http.post(uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(
              <String, String>{'bot_id': botId, 'name': name, 'email': email}));
      if (response.statusCode < 300) {
        final json = jsonDecode(response.body);
        final data = json['data']['customer'];
        data['access_token'] = json['data']['guest_token'];
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
      final url = '$baseUrl/bot-sessions/guest-auth/start-bot-session';
      final uri = Uri.parse(url);
      final response = await http.post(uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(
              <String, String>{'bot_id': botId, 'customer_auth_token': token}));
      if (response.statusCode < 300) {
        final json = jsonDecode(response.body);
        final data = json['data']['customer'];
        data['access_token'] = json['data']['guest_token'];
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

  Future<bool> createFeedback(
    String rating,
    String botId,
    String customerId,
    String blockId,
    String? ticketId,
  ) async {
    try {
      final url = '$baseUrl/messages/guest-auth/flows/feedbacks';
      final uri = Uri.parse(url);
      final payload = <String, String>{
        'bot_id': botId,
        'rating': rating,
        'customer_id': customerId,
        'block_id': blockId,
      };
      if (ticketId != null) {
        payload['ticket_id'] = ticketId;
      }
      final response = await http.post(uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(payload));
      if (response.statusCode < 300) {
        return true;
      }

      return false;
    } catch (e) {
      return false;
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

  Future<List<Message>> getMessages(String customerId, String? token) async {
    try {
      final url =
          '$baseUrl/messages/guest-auth/customer?limit=100&offset=0&order=desc&customer_id=$customerId';
      final uri = Uri.parse(url);
      final response = await http.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
      );
      if (response.statusCode < 300) {
        final json = jsonDecode(response.body);
        final data = json['data']['messages'] as List;
        final messages = data.map((message) {
          return Message.fromJson(message);
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
      if (response.statusCode < 300) {
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
      final url = '$baseUrl/tickets/$ticketId/public';
      final uri = Uri.parse(url);

      final response = await http.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );
      if (response.statusCode < 300) {
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

  Future<TicketStatusCount> getTicketCount(
      String customerId, String workspaceId) async {
    try {
      final uri = Uri(
          scheme: 'https',
          host: 'api.cxgenie.ai',
          path: '/api/v1/tickets/each-statuses',
          queryParameters: {
            'creator_id': customerId,
            'workspace_id': workspaceId,
          });

      final response = await http.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );
      if (response.statusCode < 300) {
        final json = jsonDecode(response.body);
        final data = json['data'];
        return TicketStatusCount(
          open: data['OPEN'] + data['IN_PROGRESS'],
          closed: data['SOLVED'] + data['CLOSED'] + data['MERGED'],
          all: data['OPEN'] +
              data['IN_PROGRESS'] +
              data['SOLVED'] +
              data['CLOSED'] +
              data['MERGED'],
        );
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
      if (response.statusCode < 300) {
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
      if (response.statusCode < 300) {
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
      if (response.statusCode < 300) {
        final json = jsonDecode(response.body);
        final data = json['data']['messages'] as List;
        final messages = data.map((message) {
          return Message.fromJson(message);
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

  Future<Ticket> createTicket(String workspaceId, String content,
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
      final json = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw Exception(json['error']['message']);
      }

      return Ticket.fromJson(json['data']['ticket']);
    } catch (e) {
      rethrow;
    }
  }

  Future<Customer> getCustomerDetail(String id) async {
    try {
      final url = '$baseUrl/customers/$id/public';
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      if (response.statusCode < 300) {
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

  Future<List<Map<String, String>>> uploadFiles(
      List<XFile> files, String? token) async {
    final url = '$baseUrl/files/guest-auth/multiple-upload';
    final uri = Uri.parse(url);
    var request = http.MultipartRequest("POST", uri);

    Map<String, String> headers = {'Authorization': 'Bearer $token'};
    request.headers.addAll(headers);

    for (var i = 0; i < files.length; i++) {
      var file = await http.MultipartFile.fromPath('files', files[i].path);
      request.files.add(file);
    }

    var streamResponse = await request.send();
    var response = await http.Response.fromStream(streamResponse);
    if (response.statusCode < 300) {
      var json = jsonDecode(response.body);

      return (json['urls'] as List).map((url) {
        return {'url': url as String};
      }).toList();
    }

    return [] as List<Map<String, String>>;
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
      if (response.statusCode < 300) {
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
