import 'package:cxgenie/providers/ticket_provider.dart';
import 'package:cxgenie/screens/ticket_messages.dart';
import 'package:flutter/cupertino.dart';
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
  final TextEditingController textController = TextEditingController();

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
          onPressed: () {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (content) {
                  return AlertDialog(
                    contentPadding: const EdgeInsets.all(0),
                    elevation: 0,
                    shadowColor: const Color.fromRGBO(23, 24, 26, 0.5),
                    insetPadding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    content: Container(
                      width: (MediaQuery.of(context).size.width),
                      height: 270,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  'Create ticket',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                GestureDetector(
                                  child: const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: Center(
                                      child: Icon(
                                        Icons.close,
                                        size: 18,
                                        color: Color(0xffA3A9B3),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    textController.clear();
                                    Navigator.pop(context, 'Cancel');
                                  },
                                )
                              ],
                            ),
                          ),
                          Expanded(
                              child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'What issue do you want us to support? *',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                TextField(
                                  controller: textController,
                                  autofocus: true,
                                  maxLines: 4,
                                  cursorColor: Color(int.parse(color)),
                                  decoration: InputDecoration(
                                    hintText: "Type support detail",
                                    hintStyle: const TextStyle(
                                        color: Color(0xffA3A9B3)),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(8),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                          color: Color(int.parse(color)),
                                          width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                          color: Color(0xffD6DAE1), width: 1.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                          color: Color(0xffED4245), width: 1.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                          color: Color(0xffED4245), width: 1.0),
                                    ),
                                  ),
                                  style: const TextStyle(fontSize: 14),
                                )
                              ],
                            ),
                          )),
                          Container(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: 40,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor: Colors.white,
                                        padding: const EdgeInsets.all(8),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8))),
                                    onPressed: value.isCreatingTicket
                                        ? null
                                        : () {
                                            textController.clear();
                                            Navigator.pop(context, 'Cancel');
                                          },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xff202225)),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                SizedBox(
                                  height: 40,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor:
                                            Color(int.parse(color)),
                                        padding: const EdgeInsets.all(8),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8))),
                                    onPressed: value.isCreatingTicket
                                        ? null
                                        : () {
                                            value.createTicket(
                                                widget.workspaceId,
                                                "${value.customer?.name}",
                                                "${value.customer?.email}",
                                                textController.text,
                                                "${widget.chatUserId}");
                                            textController.clear();
                                            Navigator.pop(context, 'Cancel');
                                          },
                                    child: const Text(
                                      'Create',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                });
          },
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
                        showCupertinoModalPopup(
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
                                              Expanded(
                                                  child: Text(
                                                ticket.name,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )),
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
