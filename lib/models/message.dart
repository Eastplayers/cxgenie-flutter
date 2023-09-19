import 'package:cxgenie/models/customer.dart';
import 'package:cxgenie/models/virtual_agent.dart';

class MessageMedia {
  String url;

  MessageMedia({required this.url});

  MessageMedia.fromJson(Map<String, dynamic> json) : url = json['url'];

  Map<String, dynamic> toJson() {
    return {
      'url': url,
    };
  }
}

class Message {
  String id;
  String? content;
  String? receiverId;
  String? virtualAgentId;
  String? senderId;
  String type;
  VirtualAgent? virtualAgent;
  Customer? sender;
  Customer? receiver;
  String? createdAt;
  List<MessageMedia>? media;

  Message(
      {required this.id,
      this.content,
      this.receiverId,
      this.virtualAgentId,
      this.senderId,
      required this.type,
      this.virtualAgent,
      this.sender,
      this.receiver,
      this.createdAt,
      this.media});
}
