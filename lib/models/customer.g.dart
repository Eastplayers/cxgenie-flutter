// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
      id: json['id'] as String,
      avatar: json['avatar'] as String?,
      name: json['name'] as String,
      email: json['email'] as String?,
      autoReply: json['auto_reply'] as bool?,
    );

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'id': instance.id,
      'avatar': instance.avatar,
      'name': instance.name,
      'email': instance.email,
      'auto_reply': instance.autoReply,
    };
