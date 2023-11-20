// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockAction _$BlockActionFromJson(Map<String, dynamic> json) => BlockAction(
      updatedAt: json['updated_at'] as String,
      blockId: json['block_id'] as String,
      createdAt: json['created_at'] as String,
      deletedAt: json['deleted_at'] as String?,
      type: json['type'] as String,
      id: json['id'] as String,
    );

Map<String, dynamic> _$BlockActionToJson(BlockAction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'block_id': instance.blockId,
      'updated_at': instance.updatedAt,
      'created_at': instance.createdAt,
      'deleted_at': instance.deletedAt,
    };
