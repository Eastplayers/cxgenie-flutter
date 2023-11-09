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
      assignee: json['assignee'] == null
          ? null
          : Customer.fromJson(json['assignee'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TicketToJson(Ticket instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
      'code': instance.code,
      'assignee': instance.assignee,
      'assignee_id': instance.assigneeId,
      'creator_id': instance.creatorId,
      'target_ticket_id': instance.targetTicketId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'target_ticket': instance.targetTicket,
    };
