import 'package:json_annotation/json_annotation.dart';

part 'ticket_category.g.dart';

@JsonSerializable()
class TicketCategory {
  String id;
  String name;

  @JsonKey(name: "workspace_id")
  String workspaceId;

  @JsonKey(name: "parent_id")
  String? parentId;

  @JsonKey(name: "created_at")
  String createdAt;

  @JsonKey(name: "updated_at")
  String updatedAt;

  TicketCategory(
      {required this.id,
      required this.name,
      required this.workspaceId,
      this.parentId,
      required this.createdAt,
      required this.updatedAt});

  factory TicketCategory.fromJson(Map<String, dynamic> json) =>
      _$TicketCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$TicketCategoryToJson(this);
}
