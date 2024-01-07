// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reaction _$ReactionFromJson(Map<String, dynamic> json) => Reaction(
      id: json['id'] as String,
      value: json['value'] as String,
      customerId: json['customer_id'] as String,
      messageId: json['message_id'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$ReactionToJson(Reaction instance) => <String, dynamic>{
      'id': instance.id,
      'value': instance.value,
      'customer_id': instance.customerId,
      'message_id': instance.messageId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
