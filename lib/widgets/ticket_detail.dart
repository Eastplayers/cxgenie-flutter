import 'package:cxgenie/enums/language.dart';
import 'package:cxgenie/models/ticket.dart';
import 'package:cxgenie/providers/ticket_provider.dart';
import 'package:cxgenie/widgets/ticket_messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class TicketDetail extends StatefulWidget {
  TicketDetail({
    Key? key,
    required this.workspaceId,
    required this.customerId,
    this.language = LanguageOptions.en,
    this.composerDisabled = false,
    this.themeColor = "#364DE7",
    required this.ticket,
  }) : super(key: key);

  final String workspaceId;
  final String customerId;
  final String themeColor;
  final LanguageOptions? language;
  final bool composerDisabled;
  Ticket ticket;

  @override
  TicketDetailState createState() => TicketDetailState();
}

class TicketDetailState extends State<TicketDetail> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TicketProvider(),
      child: Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: Container(
            width: (MediaQuery.of(context).size.width),
            height: (MediaQuery.of(context).size.height),
            color: Colors.white,
            child: SafeArea(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            widget.ticket.name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        GestureDetector(
                          child: const Icon(Icons.close),
                          onTap: () {
                            Navigator.pop(context, 'Cancel');
                          },
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: TicketMessages(
                      ticketId: widget.ticket.id,
                      themeColor: widget.themeColor,
                      customerId: widget.customerId,
                      workspaceId: widget.workspaceId,
                      language: widget.language,
                      composerDisabled: widget.ticket.status == 'CLOSED' ||
                          widget.ticket.status == 'MERGED' ||
                          widget.ticket.status == 'SOLVED',
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
