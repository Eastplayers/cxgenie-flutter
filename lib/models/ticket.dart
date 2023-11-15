import 'package:cxgenie/models/bot.dart';
import 'package:cxgenie/models/customer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ticket.g.dart';

@JsonSerializable()
class Ticket {
  String id;
  String name;
  String status;
  int code;
  Customer? assignee;
  Bot? bot;

  @JsonKey(name: "assignee_id")
  String? assigneeId;

  @JsonKey(name: "creator_id")
  String creatorId;

  @JsonKey(name: "target_ticket_id")
  String? targetTicketId;

  @JsonKey(name: "created_at")
  String createdAt;

  @JsonKey(name: "updated_at")
  String updatedAt;

  @JsonKey(name: "target_ticket")
  Ticket? targetTicket;

  @JsonKey(name: "auto_reply")
  bool autoReply;

  @JsonKey(name: "bot_id")
  String? botId;

  Ticket(
      {required this.id,
      required this.name,
      required this.status,
      required this.code,
      this.assigneeId,
      this.targetTicketId,
      required this.createdAt,
      required this.updatedAt,
      this.targetTicket,
      required this.creatorId,
      required this.autoReply,
      this.botId,
      this.assignee,
      this.bot});

  factory Ticket.fromJson(Map<String, dynamic> json) => _$TicketFromJson(json);

  Map<String, dynamic> toJson() => _$TicketToJson(this);
}
