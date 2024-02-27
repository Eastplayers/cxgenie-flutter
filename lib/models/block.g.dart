// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Block _$BlockFromJson(Map<String, dynamic> json) => Block(
      id: json['id'] as String,
      type: json['type'] as String,
      data: BlockData.fromJson(json['data'] as Map<String, dynamic>),
      actions: (json['actions'] as List<dynamic>)
          .map((e) => BlockAction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BlockToJson(Block instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'data': instance.data,
      'actions': instance.actions,
    };
