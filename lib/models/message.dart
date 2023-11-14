import 'package:cxgenie/models/bot.dart';
import 'package:cxgenie/models/customer.dart';

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
  String? id;
  String? content;
  String? receiverId;
  String? botId;
  String? senderId;
  String type;
  Bot? bot;
  Customer? sender;
  Customer? receiver;
  String? createdAt;
  List<MessageMedia>? media;
  String? workspaceId;

  Message(
      {this.id,
      this.content,
      this.receiverId,
      this.bot,
      this.senderId,
      required this.type,
      this.botId,
      this.sender,
      this.receiver,
      this.createdAt,
      this.media,
      this.workspaceId});
}
