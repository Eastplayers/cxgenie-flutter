// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockData _$BlockDataFromJson(Map<String, dynamic> json) => BlockData(
      label: json['label'] as String,
      content: json['content'] as String?,
      localId: json['local_id'] as String?,
    );

Map<String, dynamic> _$BlockDataToJson(BlockData instance) => <String, dynamic>{
      'label': instance.label,
      'content': instance.content,
      'local_id': instance.localId,
    };
