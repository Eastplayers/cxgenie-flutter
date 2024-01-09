// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ticket _$TicketFromJson(Map<String, dynamic> json) => Ticket(
      id: json['id'] as String,
      name: json['name'] as String,
      status: json['status'] as String,
      code: json['code'] as int,
      assigneeId: json['assignee_id'] as String?,
      targetTicketId: json['target_ticket_id'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      targetTicket: json['target_ticket'] == null
          ? null
          : Ticket.fromJson(json['target_ticket'] as Map<String, dynamic>),
      creatorId: json['creator_id'] as String,
      autoReply: json['auto_reply'] as bool,
      botId: json['bot_id'] as String?,
      assignee: json['assignee'] == null
          ? null
          : Customer.fromJson(json['assignee'] as Map<String, dynamic>),
      bot: json['bot'] == null
          ? null
          : Bot.fromJson(json['bot'] as Map<String, dynamic>),
      isReplied: json['is_replied'] as bool?,
      ticketCategory: json['ticket_category'] == null
          ? null
          : TicketCategory.fromJson(
              json['ticket_category'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TicketToJson(Ticket instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
      'code': instance.code,
      'assignee': instance.assignee,
      'bot': instance.bot,
      'is_replied': instance.isReplied,
      'assignee_id': instance.assigneeId,
      'creator_id': instance.creatorId,
      'target_ticket_id': instance.targetTicketId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'target_ticket': instance.targetTicket,
      'auto_reply': instance.autoReply,
      'bot_id': instance.botId,
      'ticket_category': instance.ticketCategory,
    };
