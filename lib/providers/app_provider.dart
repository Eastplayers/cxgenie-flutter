import 'package:cxgenie/models/bot.dart';
import 'package:cxgenie/models/customer.dart';
import 'package:cxgenie/models/message.dart';
import 'package:cxgenie/services/app_service.dart';
import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  final AppService _service = AppService();
  bool isLoading = true;
  bool isStartingSession = false;
  bool isLoadingMessages = true;
  Bot _bot = Bot(
      id: "",
      name: "",
      themeColor: "#364DE7",
      createdAt: "",
      updatedAt: "",
      workspaceId: "");
  Bot get bot => _bot;
  Customer? _customer;
  Customer? get customer => _customer;

  List<Message> _messages = [];
  List<Message> get messages => _messages;

  String? _selectedTicketMessageId;
  String? get selectedTicketMessageId => _selectedTicketMessageId;

  Future<void> getBotDetail(String id, String? token) async {
    isLoading = true;
    notifyListeners();

    final response = await _service.getBotDetail(id);
    _bot = response;
    if (response.workspaceRequiredLogin != null &&
        response.workspaceRequiredLogin != false &&
        token != null) {
      final customerResponse = await _service.startAuthorizedSession(id, token);
      _customer = customerResponse;
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> startNormalSession(
      String virtualAgentId, String name, String email) async {
    isStartingSession = true;
    notifyListeners();

    final response = await _service.startSession(virtualAgentId, name, email);
    _customer = response;
    isStartingSession = false;
    notifyListeners();
  }

  Future<void> getMessages(String customerId) async {
    isLoadingMessages = true;
    notifyListeners();

    final response = await _service.getMessages(customerId);
    _messages = response;
    isLoadingMessages = false;
    notifyListeners();
  }

  Future<void> addMessage(Message newMessage) async {
    _messages = [newMessage, ..._messages];
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
}
