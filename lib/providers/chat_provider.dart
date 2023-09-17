import 'package:cxgenie/models/customer.dart';
import 'package:cxgenie/models/message.dart';
import 'package:cxgenie/models/virtual_agent.dart';
import 'package:cxgenie/services/chat_service.dart';
import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  final ChatService _service = ChatService();
  bool isLoading = true;
  bool isStartingSession = true;
  bool isLoadingMessages = true;
  VirtualAgent _virtualAgent = VirtualAgent(
      id: "",
      name: "",
      themeColor: "#364DE7",
      createdAt: "",
      updatedAt: "",
      workspaceId: "");
  VirtualAgent get virtualAgent => _virtualAgent;
  Customer? _customer;
  Customer? get customer => _customer;

  List<Message> _messages = [];
  List<Message> get messages => _messages;

  Future<void> getVirtualAgentDetail(String id, String? token) async {
    isLoading = true;
    notifyListeners();

    final response = await _service.getDetail(id);
    _virtualAgent = response;
    print(response.workspaceRequiredLogin);
    print(token);
    if (response.workspaceRequiredLogin != null && token != null) {
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
    notifyListeners();

    _messages = [newMessage, ..._messages];
    notifyListeners();
  }
}
