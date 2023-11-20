// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Block _$BlockFromJson(Map<String, dynamic> json) => Block(
      actions: (json['actions'] as List<dynamic>)
          .map((e) => BlockAction.fromJson(e as Map<String, dynamic>))
          .toList(),
      updatedAt: json['updated_at'] as String,
      type: json['type'] as String,
      createdAt: json['created_at'] as String,
      deletedAt: json['deleted_at'] as String?,
      targetFlowId: json['target_flow_id'] as String?,
      flowId: json['flow_id'] as String,
      id: json['id'] as String,
    );

Map<String, dynamic> _$BlockToJson(Block instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'actions': instance.actions,
      'target_flow_id': instance.targetFlowId,
      'flow_id': instance.flowId,
      'updated_at': instance.updatedAt,
      'created_at': instance.createdAt,
      'deleted_at': instance.deletedAt,
    };
