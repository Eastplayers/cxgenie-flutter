import 'package:json_annotation/json_annotation.dart';

part 'block_data.g.dart';

@JsonSerializable()
class BlockData {
  String label;
  String? content;

  @JsonKey(name: "local_id")
  String? localId;

  BlockData({
    required this.label,
    this.content,
    this.localId,
  });

  factory BlockData.fromJson(Map<String, dynamic> json) =>
      _$BlockDataFromJson(json);

  Map<String, dynamic> toJson() => _$BlockDataToJson(this);
}
