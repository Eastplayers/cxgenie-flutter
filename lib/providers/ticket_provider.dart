import 'package:cxgenie/models/message.dart';
import 'package:cxgenie/models/ticket.dart';
import 'package:cxgenie/services/chat_service.dart';
import 'package:flutter/material.dart';

class TicketProvider extends ChangeNotifier {
  final ChatService _service = ChatService();
  bool isTicketListLoading = true;
  String? chatUserId;
  String? currentWorkspaceId;
  bool isLoadingMessages = true;

  List<Ticket> _tickets = [];
  List<Ticket> get tickets => _tickets;

  List<Message> _messages = [];
  List<Message> get messages => _messages;

  Future<void> getTickets(String customerId, String workspaceId) async {
    chatUserId = customerId;
    currentWorkspaceId = workspaceId;
    isTicketListLoading = true;
    notifyListeners();

    final response = await _service.getTickets(customerId, workspaceId);
    _tickets = response;
    isTicketListLoading = false;
    notifyListeners();
  }

  Future<void> getMessages(String ticketId) async {
    isLoadingMessages = true;
    notifyListeners();

    final response = await _service.getTicketMessages(ticketId);
    _messages = response;
    isLoadingMessages = false;
    notifyListeners();
  }

  Future<void> addMessage(Message newMessage) async {
    notifyListeners();

    _messages = [newMessage, ..._messages];
    notifyListeners();
  }
}
