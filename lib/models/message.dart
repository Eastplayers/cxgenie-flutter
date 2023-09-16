import 'package:cxgenie/models/customer.dart';
import 'package:cxgenie/models/virtual_agent.dart';

class Message {
  String id;
  String content;
  String? receiverId;
  String? virtualAgentId;
  String? senderId;
  String type;
  VirtualAgent? virtualAgent;
  Customer? sender;
  Customer? receiver;
  String? createdAt;

  Message(
      {required this.id,
      required this.content,
      this.receiverId,
      this.virtualAgentId,
      this.senderId,
      required this.type,
      this.virtualAgent,
      this.sender,
      this.receiver,
      this.createdAt});
}
