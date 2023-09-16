import 'package:cxgenie/models/customer.dart';
import 'package:cxgenie/models/message.dart';
import 'package:cxgenie/models/virtual_agent.dart';
import 'package:cxgenie/services/chat_service.dart';
import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  final ChatService _service = ChatService();
  bool isLoading = false;
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

  Future<void> getVirtualAgentDetail(String id) async {
    isLoading = true;
    notifyListeners();

    final response = await _service.getDetail(id);
    _virtualAgent = response;
    isLoading = false;
    notifyListeners();
  }

  Future<void> startNormalSession(
      String virtualAgentId, String name, String email) async {
    isLoading = true;
    notifyListeners();

    final response = await _service.startSession(virtualAgentId, name, email);
    _customer = response;
    isLoading = false;
    notifyListeners();
  }

  Future<void> getMessages(String customerId) async {
    isLoading = true;
    notifyListeners();

    final response = await _service.getMessages(customerId);
    _messages = response;
    isLoading = false;
    notifyListeners();
  }
}
