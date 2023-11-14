import 'package:cxgenie/models/customer.dart';
import 'package:cxgenie/models/message.dart';
import 'package:cxgenie/models/ticket.dart';
import 'package:cxgenie/models/ticket_category.dart';
import 'package:cxgenie/services/app_service.dart';
import 'package:flutter/material.dart';

class TicketProvider extends ChangeNotifier {
  final AppService _service = AppService();
  bool isTicketListLoading = true;
  bool isTicketCategoryLoading = true;
  String? chatUserId;
  String? currentWorkspaceId;
  bool isLoadingMessages = true;
  bool isCreatingTicket = false;

  List<Ticket> _tickets = [];
  List<Ticket> get tickets => _tickets;

  List<TicketCategory> _ticketCategories = [];
  List<TicketCategory> get ticketCategories => _ticketCategories;

  List<Message> _messages = [];
  List<Message> get messages => _messages;

  Customer? _customer;
  Customer? get customer => _customer;

  Future<void> getTickets(
      String customerId, String workspaceId, List<String> statuses) async {
    chatUserId = customerId;
    currentWorkspaceId = workspaceId;
    isTicketListLoading = true;
    notifyListeners();

    final response =
        await _service.getTickets(customerId, workspaceId, statuses);
    _tickets = response;

    final customerResponse = await _service.getCustomerDetail(customerId);
    _customer = customerResponse;

    isTicketListLoading = false;
    notifyListeners();
  }

  Future<void> getTicketCategories(
    String workspaceId,
  ) async {
    isTicketCategoryLoading = true;
    notifyListeners();

    final response = await _service.getTicketCategories(workspaceId);
    _ticketCategories = response;

    isTicketCategoryLoading = false;
    notifyListeners();
  }

  Future<void> createTicket(String workspaceId, String content,
      String customerId, String? categoryId) async {
    isCreatingTicket = true;
    notifyListeners();

    await _service.createTicket(workspaceId, content, customerId, categoryId);
    final ticketsResponse = await _service
        .getTickets(customerId, workspaceId, ['OPEN', 'IN_PROGRESS']);
    _tickets = ticketsResponse;
    isCreatingTicket = false;
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
