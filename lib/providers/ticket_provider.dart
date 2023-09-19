import 'package:cxgenie/models/ticket.dart';
import 'package:cxgenie/services/chat_service.dart';
import 'package:flutter/material.dart';

class TicketProvider extends ChangeNotifier {
  final ChatService _service = ChatService();
  bool isTicketListLoading = true;
  String? chatUserId;
  String? currentWorkspaceId;

  List<Ticket> _tickets = [];
  List<Ticket> get tickets => _tickets;

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
}
