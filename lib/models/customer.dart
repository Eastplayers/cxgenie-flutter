import 'package:json_annotation/json_annotation.dart';

part 'customer.g.dart';

@JsonSerializable()
class Customer {
  final String id;
  final String? avatar;
  final String name;
  final String? email;

  @JsonKey(name: "access_token")
  final String? accessToken;

  @JsonKey(name: "auto_reply")
  final bool? autoReply;

  Customer({
    required this.id,
    this.avatar,
    required this.name,
    this.email,
    this.autoReply,
    this.accessToken,
  });

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}
