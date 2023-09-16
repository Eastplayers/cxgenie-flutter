import 'package:cxgenie/models/customer.dart';
import 'package:cxgenie/models/virtual_agent.dart';
import 'package:cxgenie/services/virtual_agent_service.dart';
import 'package:flutter/material.dart';

class VirtualAgentProvider extends ChangeNotifier {
  final VirtualAgentService _service = VirtualAgentService();
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
}
