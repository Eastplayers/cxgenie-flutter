import 'package:cxgenie/models/block_action.dart';
import 'package:json_annotation/json_annotation.dart';

part 'block.g.dart';

@JsonSerializable()
class Block {
  String id;
  String type;
  List<BlockAction> actions;

  @JsonKey(name: "target_flow_id")
  final String? targetFlowId;

  @JsonKey(name: "flow_id")
  final String flowId;

  @JsonKey(name: "updated_at")
  final String updatedAt;

  @JsonKey(name: "created_at")
  final String createdAt;

  @JsonKey(name: "deleted_at")
  final String? deletedAt;

  Block({
    required this.actions,
    required this.updatedAt,
    required this.type,
    required this.createdAt,
    this.deletedAt,
    this.targetFlowId,
    required this.flowId,
    required this.id,
  });

  factory Block.fromJson(Map<String, dynamic> json) => _$BlockFromJson(json);

  Map<String, dynamic> toJson() => _$BlockToJson(this);
}
