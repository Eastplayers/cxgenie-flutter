import 'package:json_annotation/json_annotation.dart';

part 'reaction.g.dart';

@JsonSerializable()
class Reaction {
  String id;
  String value;

  @JsonKey(name: "customer_id")
  String customerId;

  @JsonKey(name: "message_id")
  String messageId;

  @JsonKey(name: "created_at")
  String createdAt;

  @JsonKey(name: "updated_at")
  String updatedAt;

  Reaction({
    required this.id,
    required this.value,
    required this.customerId,
    required this.messageId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Reaction.fromJson(Map<String, dynamic> json) =>
      _$ReactionFromJson(json);

  Map<String, dynamic> toJson() => _$ReactionToJson(this);
}
