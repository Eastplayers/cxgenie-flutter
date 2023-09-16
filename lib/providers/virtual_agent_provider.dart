import 'package:cxgenie/models/virtual_agent.dart';
import 'package:cxgenie/services/virtual_agent_service.dart';
import 'package:flutter/material.dart';

class VirtualAgentProvider extends ChangeNotifier {
  final VirtualAgentService _service = VirtualAgentService();
  bool isLoading = false;
  VirtualAgent _virtualAgent = VirtualAgent(
      id: "",
      name: "",
      themeColor: "",
      createdAt: "",
      updatedAt: "",
      workspaceId: "");
  VirtualAgent get virtualAgent => _virtualAgent;

  Future<void> getVirtualAgentDetail(String id) async {
    isLoading = true;
    notifyListeners();

    final response = await _service.getDetail(id);
    _virtualAgent = response;
    isLoading = false;
    notifyListeners();
  }
}
