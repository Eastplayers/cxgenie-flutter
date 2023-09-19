import 'package:cxgenie/providers/ticket_provider.dart';
import 'package:cxgenie/screens/ticket_messages.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

Map<String, Map<String, Color>> colorMap = {
  'OPEN': {
    'background': const Color(0xffD8E2F8),
    'color': const Color(0xff3E70DD)
  },
  'IN_PROGRESS': {
    'background': const Color(0xffFFEFD6),
    'color': const Color(0xffFFB130)
  },
  'SOLVED': {
    'background': const Color(0xffD8EDDE),
    'color': const Color(0xff3BA55C)
  },
  'MERGED': {
    'background': const Color(0xffDCCCFF),
    'color': const Color(0xff702DFF)
  },
  'CLOSED': {
    'background': const Color(0xffE3E5E8),
    'color': const Color(0xff747F8D)
  },
};

class TicketList extends StatefulWidget {
  const TicketList(
      {Key? key,
      required this.workspaceId,
      this.chatUserId,
      this.userToken,
      required this.themeColor})
      : super(key: key);

  final String workspaceId;
  final String? chatUserId;
  final String? userToken;
  final String themeColor;

  @override
  _TicketListState createState() => _TicketListState();
}

class _TicketListState extends State<TicketList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<TicketProvider>(context, listen: false)
          .getTickets("${widget.chatUserId}", widget.workspaceId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TicketProvider>(builder: (context, value, child) {
      String color = widget.themeColor.replaceAll("#", "0xff");

      return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Color(int.parse(color)),
          child: const Icon(Icons.add),
          elevation: 0,
        ),
        backgroundColor: Color(0xffF2F3F5),
        body: SafeArea(
            child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                itemCount: value.tickets.length,
                itemBuilder: (context, index) {
                  var ticket = value.tickets[index];

                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: GestureDetector(
                      onTap: () {
                        print("ON ITEM TAP");
                        showAdaptiveDialog(
                            context: context,
                            builder: (content) {
                              return ChangeNotifierProvider(
                                create: (context) => TicketProvider(),
                                child: Scaffold(
                                  body: Container(
                                    width: (MediaQuery.of(context).size.width),
                                    height:
                                        (MediaQuery.of(context).size.height),
                                    color: Colors.white,
                                    child: SafeArea(
                                        child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 16),
                                          color: Colors.white,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                ticket.name,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              const SizedBox(
                                                width: 12,
                                              ),
                                              GestureDetector(
                                                child: Icon(Icons.close),
                                                onTap: () {
                                                  Navigator.pop(
                                                      context, 'Cancel');
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                            child: TicketMessages(
                                          ticketId: ticket.id,
                                          themeColor: widget.themeColor,
                                          chatUserId: "${widget.chatUserId}",
                                          workspaceId: widget.workspaceId,
                                        ))
                                      ],
                                    )),
                                  ),
                                ),
                              );
                            });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "#${ticket.code}",
                                    style: const TextStyle(
                                        color: Color(0xff7D828B), fontSize: 14),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: colorMap[ticket.status]
                                            ?['background']),
                                    child: Text(
                                      "${toBeginningOfSentenceCase(ticket.status.toLowerCase())}",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: colorMap[ticket.status]
                                              ?['color']),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                ticket.name,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    color: Color(0xff2C2E33),
                                    fontWeight: FontWeight.w700),
                              )
                            ]),
                      ),
                    ),
                  );
                })),
      );
    });
  }
}
