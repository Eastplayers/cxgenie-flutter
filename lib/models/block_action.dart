import 'package:json_annotation/json_annotation.dart';

part 'block_action.g.dart';

@JsonSerializable()
class BlockAction {
  String id;
  String type;

  @JsonKey(name: "block_id")
  final String blockId;

  @JsonKey(name: "updated_at")
  final String updatedAt;

  @JsonKey(name: "created_at")
  final String createdAt;

  @JsonKey(name: "deleted_at")
  final String? deletedAt;

  BlockAction({
    required this.updatedAt,
    required this.blockId,
    required this.createdAt,
    this.deletedAt,
    required this.type,
    required this.id,
  });

  factory BlockAction.fromJson(Map<String, dynamic> json) =>
      _$BlockActionFromJson(json);

  Map<String, dynamic> toJson() => _$BlockActionToJson(this);
}
