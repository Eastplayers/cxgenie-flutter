// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageMedia _$MessageMediaFromJson(Map<String, dynamic> json) => MessageMedia(
      url: json['url'] as String,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$MessageMediaToJson(MessageMedia instance) =>
    <String, dynamic>{
      'url': instance.url,
      'type': instance.type,
    };

MessageReactions _$MessageReactionsFromJson(Map<String, dynamic> json) =>
    MessageReactions(
      like: (json['like'] as List<dynamic>?)
          ?.map((e) => Reaction.fromJson(e as Map<String, dynamic>))
          .toList(),
      dislike: (json['dislike'] as List<dynamic>?)
          ?.map((e) => Reaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MessageReactionsToJson(MessageReactions instance) =>
    <String, dynamic>{
      'like': instance.like,
      'dislike': instance.dislike,
    };

MessageMetaTag _$MessageMetaTagFromJson(Map<String, dynamic> json) =>
    MessageMetaTag(
      description: json['description'] as String?,
      image: json['image'] as String?,
      title: json['title'] as String,
      url: json['url'] as String,
    );

Map<String, dynamic> _$MessageMetaTagToJson(MessageMetaTag instance) =>
    <String, dynamic>{
      'description': instance.description,
      'image': instance.image,
      'title': instance.title,
      'url': instance.url,
    };

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      id: json['id'] as String?,
      content: json['content'] as String?,
      receiverId: json['receiver_id'] as String?,
      bot: json['bot'] == null
          ? null
          : Bot.fromJson(json['bot'] as Map<String, dynamic>),
      senderId: json['sender_id'] as String?,
      type: json['type'] as String?,
      botId: json['bot_id'] as String?,
      sender: json['sender'] == null
          ? null
          : Customer.fromJson(json['sender'] as Map<String, dynamic>),
      receiver: json['receiver'] == null
          ? null
          : Customer.fromJson(json['receiver'] as Map<String, dynamic>),
      createdAt: json['created_at'] as String?,
      media: (json['media'] as List<dynamic>?)
          ?.map((e) => MessageMedia.fromJson(e as Map<String, dynamic>))
          .toList(),
      workspaceId: json['workspace_id'] as String?,
      reactions: json['reactions'] == null
          ? null
          : MessageReactions.fromJson(
              json['reactions'] as Map<String, dynamic>),
      sendingStatus: json['sending_status'] as String?,
      localId: json['local_id'] as String?,
      quotedId: json['quoted_id'] as String?,
      quotedFrom: json['quoted_from'] == null
          ? null
          : Message.fromJson(json['quoted_from'] as Map<String, dynamic>),
      unsent: json['unsent'] as bool?,
      block: json['block'] == null
          ? null
          : Block.fromJson(json['block'] as Map<String, dynamic>),
      metaTags: (json['meta_tags'] as List<dynamic>)
          .map((e) => MessageMetaTag.fromJson(e as Map<String, dynamic>))
          .toList(),
      variables: (json['variables'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'type': instance.type,
      'bot': instance.bot,
      'sender': instance.sender,
      'receiver': instance.receiver,
      'media': instance.media,
      'reactions': instance.reactions,
      'unsent': instance.unsent,
      'block': instance.block,
      'variables': instance.variables,
      'receiver_id': instance.receiverId,
      'sender_id': instance.senderId,
      'bot_id': instance.botId,
      'created_at': instance.createdAt,
      'workspace_id': instance.workspaceId,
      'sending_status': instance.sendingStatus,
      'local_id': instance.localId,
      'quoted_id': instance.quotedId,
      'quoted_from': instance.quotedFrom,
      'meta_tags': instance.metaTags,
    };
