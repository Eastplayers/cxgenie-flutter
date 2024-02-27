// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockAction _$BlockActionFromJson(Map<String, dynamic> json) => BlockAction(
      data: BlockData.fromJson(json['data'] as Map<String, dynamic>),
      id: json['id'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$BlockActionToJson(BlockAction instance) =>
    <String, dynamic>{
      'data': instance.data,
      'id': instance.id,
      'type': instance.type,
    };
