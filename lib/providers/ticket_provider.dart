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
  bool isCreated = false;

  String? _selectedTicketMessageId;
  String? get selectedTicketMessageId => _selectedTicketMessageId;

  int _selectedPage = 0;
  int get selectedPage => _selectedPage;

  TicketStatusCount _ticketStatusCount =
      TicketStatusCount(open: 0, closed: 0, all: 0);
  TicketStatusCount get ticketStatusCount => _ticketStatusCount;

  List<Ticket> _tickets = [];
  List<Ticket> get tickets => _tickets;

  List<TicketCategory> _ticketCategories = [];
  List<TicketCategory> get ticketCategories => _ticketCategories;

  List<TicketCategory> _ticketSubCategories = [];
  List<TicketCategory> get ticketSubCategories => _ticketSubCategories;

  List<Message> _messages = [];
  List<Message> get messages => _messages;

  Customer? _customer;
  Customer? get customer => _customer;

  Future<void> getTicketStatusCount(
      String customerId, String workspaceId) async {
    final response = await _service.getTicketCount(customerId, workspaceId);
    _ticketStatusCount = response;

    notifyListeners();
  }

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

  Future<void> getTicketSubCategories(
      String workspaceId, String parentId) async {
    notifyListeners();
    _ticketSubCategories = [];

    final response =
        await _service.getTicketSubCategories(workspaceId, parentId);
    _ticketSubCategories = response;

    notifyListeners();
  }

  Future<Ticket> createTicket(String workspaceId, String content,
      String customerId, String? categoryId, List<String> statuses) async {
    isCreatingTicket = true;
    isCreated = false;
    notifyListeners();

    final createdTicket = await _service.createTicket(
        workspaceId, content, customerId, categoryId);

    final ticketsResponse =
        await _service.getTickets(customerId, workspaceId, statuses);

    getTicketStatusCount(customerId, workspaceId);

    _tickets = ticketsResponse;
    isCreatingTicket = false;
    isCreated = true;
    notifyListeners();

    return createdTicket;
  }

  Future<void> getMessages(String ticketId) async {
    isLoadingMessages = true;
    notifyListeners();
    final response = await _service.getTicketMessages(ticketId);
    _messages = response;
    isLoadingMessages = false;
    notifyListeners();
  }

  void updateMessageReactions(
      String messageId, MessageReactions reactions) async {
    notifyListeners();
    _messages = _messages.map((message) {
      if (message.id == messageId) {
        message.reactions = reactions;
        return message;
      }

      return message;
    }).toList();
    notifyListeners();
  }

  void updateSelectedTicketMessage(String? id) {
    _selectedTicketMessageId = id;
    notifyListeners();
  }

  void setSelectedPage(int page) {
    _selectedPage = page;
    notifyListeners();
  }

  Future<void> addMessage(Message newMessage) async {
    _messages = [newMessage, ..._messages];
    notifyListeners();
  }

  Future<void> updateMessage(Message newMessage) async {
    _messages[_messages.indexWhere((m) => m.id == newMessage.id)] = newMessage;
    notifyListeners();
  }
}
