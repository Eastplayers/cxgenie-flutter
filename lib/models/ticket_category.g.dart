// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicketCategory _$TicketCategoryFromJson(Map<String, dynamic> json) =>
    TicketCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      workspaceId: json['workspace_id'] as String,
      parentId: json['parent_id'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      parent: json['parent'] == null
          ? null
          : TicketCategory.fromJson(json['parent'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TicketCategoryToJson(TicketCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'workspace_id': instance.workspaceId,
      'parent_id': instance.parentId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'parent': instance.parent,
    };
