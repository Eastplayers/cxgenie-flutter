import 'package:cxgenie/models/block_action.dart';
import 'package:cxgenie/models/block_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'block.g.dart';

@JsonSerializable()
class Block {
  String id;
  String type;
  BlockData data;
  List<BlockAction> actions;

  Block({
    required this.id,
    required this.type,
    required this.data,
    required this.actions,
  });

  factory Block.fromJson(Map<String, dynamic> json) => _$BlockFromJson(json);

  Map<String, dynamic> toJson() => _$BlockToJson(this);
}
