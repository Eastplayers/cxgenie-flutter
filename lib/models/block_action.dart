import 'package:cxgenie/models/block_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'block_action.g.dart';

@JsonSerializable()
class BlockAction {
  BlockData data;
  String id;
  String type;

  BlockAction({
    required this.data,
    required this.id,
    required this.type,
  });

  factory BlockAction.fromJson(Map<String, dynamic> json) =>
      _$BlockActionFromJson(json);

  Map<String, dynamic> toJson() => _$BlockActionToJson(this);
}
