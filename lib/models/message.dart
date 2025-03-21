import 'package:cxgenie/models/block.dart';
import 'package:cxgenie/models/bot.dart';
import 'package:cxgenie/models/customer.dart';
import 'package:cxgenie/models/reaction.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class MessageMedia {
  String url;
  String? type;

  MessageMedia({
    required this.url,
    this.type,
  });

  factory MessageMedia.fromJson(Map<String, dynamic> json) =>
      _$MessageMediaFromJson(json);

  Map<String, dynamic> toJson() => _$MessageMediaToJson(this);
}

@JsonSerializable()
class MessageReactions {
  List<Reaction>? like;
  List<Reaction>? dislike;

  MessageReactions({
    this.like,
    this.dislike,
  });

  factory MessageReactions.fromJson(Map<String, dynamic> json) =>
      _$MessageReactionsFromJson(json);

  Map<String, dynamic> toJson() => _$MessageReactionsToJson(this);
}

@JsonSerializable()
class MessageMetaTag {
  String? description;
  String? image;
  String title;
  String url;

  MessageMetaTag({
    this.description,
    this.image,
    required this.title,
    required this.url,
  });

  factory MessageMetaTag.fromJson(Map<String, dynamic> json) =>
      _$MessageMetaTagFromJson(json);

  Map<String, dynamic> toJson() => _$MessageMetaTagToJson(this);
}

@JsonSerializable()
class Message {
  String? id;
  String? content;
  String? type;
  Bot? bot;
  Customer? sender;
  Customer? receiver;
  List<MessageMedia>? media;
  MessageReactions? reactions;
  bool? unsent;
  Block? block;
  Map<String, dynamic>? variables;
  int? rating;

  @JsonKey(name: "receiver_id")
  String? receiverId;

  @JsonKey(name: "sender_id")
  String? senderId;

  @JsonKey(name: "bot_id")
  String? botId;

  @JsonKey(name: "created_at")
  String? createdAt;

  @JsonKey(name: "workspace_id")
  String? workspaceId;

  @JsonKey(name: "sending_status")
  String? sendingStatus;

  @JsonKey(name: "local_id")
  String? localId;

  @JsonKey(name: "quoted_id")
  String? quotedId;

  @JsonKey(name: "quoted_from")
  Message? quotedFrom;

  @JsonKey(name: "meta_tags")
  List<MessageMetaTag>? metaTags;

  @JsonKey(name: "is_cta")
  bool? isCta;

  Message({
    this.id,
    this.content,
    this.receiverId,
    this.bot,
    this.senderId,
    this.type,
    this.botId,
    this.sender,
    this.receiver,
    this.createdAt,
    this.media,
    this.workspaceId,
    this.reactions,
    this.sendingStatus,
    this.localId,
    this.quotedId,
    this.quotedFrom,
    required this.unsent,
    this.block,
    this.metaTags,
    this.variables,
    this.isCta,
    this.rating,
  });

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
