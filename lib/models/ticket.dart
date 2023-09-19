import 'package:cxgenie/models/customer.dart';

class Ticket {
  String id;
  String name;
  String status;
  int code;
  String? assigneeId;
  String creatorId;
  String? targetTicketId;
  String createdAt;
  String updatedAt;
  Ticket? targetTicket;
  Customer? assignee;

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
      this.assignee});
}
