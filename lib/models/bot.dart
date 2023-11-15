import 'package:json_annotation/json_annotation.dart';

part 'bot.g.dart';

@JsonSerializable()
class Bot {
  final String id;
  final String? avatar;
  final String name;

  @JsonKey(name: "theme_color")
  final String? themeColor;

  @JsonKey(name: "reply_language")
  final String? replyLanguage;

  @JsonKey(name: "created_at")
  final String? createdAt;

  @JsonKey(name: "updated_at")
  final String? updatedAt;

  @JsonKey(name: "deleted_at")
  final String? deletedAt;

  @JsonKey(name: "workspace_required_login")
  final bool? workspaceRequiredLogin;

  @JsonKey(name: "is_ticket_enable")
  final bool? isTicketEnable;

  @JsonKey(name: "workspace_id")
  final String? workspaceId;

  Bot(
      {required this.id,
      this.avatar,
      required this.name,
      this.themeColor,
      this.replyLanguage,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.workspaceRequiredLogin,
      this.isTicketEnable,
      this.workspaceId});

  factory Bot.fromJson(Map<String, dynamic> json) => _$BotFromJson(json);

  Map<String, dynamic> toJson() => _$BotToJson(this);
}
