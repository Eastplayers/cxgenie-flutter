import 'package:cxgenie/enums/language.dart';
import 'package:cxgenie/providers/app_provider.dart';
import 'package:cxgenie/providers/ticket_provider.dart';
import 'package:cxgenie/widgets/ticket_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Map<String, Map<LanguageOptions, String>> nameMap = {
  "0": {LanguageOptions.en: 'Open', LanguageOptions.vi: 'Đang mở'},
  "1": {LanguageOptions.en: 'Closed', LanguageOptions.vi: 'Đã đóng'},
  "2": {LanguageOptions.en: 'All', LanguageOptions.vi: 'Tất cả'},
};

class TicketTab extends StatefulWidget {
  const TicketTab({
    Key? key,
    required this.workspaceId,
    this.customerId,
    this.userToken,
    this.language = LanguageOptions.en,
    required this.themeColor,
  }) : super(key: key);

  final String workspaceId;
  final String? customerId;
  final String? userToken;
  final String themeColor;
  final LanguageOptions? language;

  @override
  TicketTabState createState() => TicketTabState();
}

class TicketTabState extends State<TicketTab> {
  final int pageCount = 3;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<TicketProvider>(context, listen: false)
          .getTicketStatusCount("${widget.customerId}", widget.workspaceId);
    });
  }

  @override
  Widget build(BuildContext context) {
    Color color = Color(int.parse(widget.themeColor.replaceAll("#", "0xff")));

    return Consumer<TicketProvider>(builder: (context, value, child) {
      int selectedPage = value.selectedPage;
      return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [0, 1, 2]
                    .map(
                      (k) => Container(
                        margin: EdgeInsets.only(left: k == 0 ? 0 : 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: selectedPage == k
                              ? color.withOpacity(0.1)
                              : const Color(0xffF2F3F5),
                          border: Border.all(
                              color: selectedPage == k
                                  ? color
                                  : const Color(0xffF2F3F5),
                              width: 1),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            value.setSelectedPage(k);
                            value.getTickets(
                                "${widget.customerId}",
                                widget.workspaceId,
                                k == 0
                                    ? const ['OPEN', 'IN_PROGRESS']
                                    : k == 1
                                        ? const ['SOLVED', 'CLOSED']
                                        : const [
                                            'OPEN',
                                            'IN_PROGRESS',
                                            'SOLVED',
                                            'CLOSED'
                                          ]);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 12),
                            child: Text(
                              "${nameMap["$k"]![widget.language]} (${k == 0 ? value.ticketStatusCount.open : k == 1 ? value.ticketStatusCount.closed : value.ticketStatusCount.all})",
                              style: TextStyle(
                                color: selectedPage == k
                                    ? color
                                    : const Color(0xff5C6169),
                                fontWeight:
                                    selectedPage == k ? FontWeight.w600 : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            // const Divider(
            //   height: 1,
            //   color: Color(0xffD6DAE1),
            // ),
            Expanded(
              child: TicketList(
                workspaceId: widget.workspaceId,
                themeColor: widget.themeColor,
                customerId: widget.customerId,
                language: widget.language,
              ),
            )
          ],
        ),
      );
    });
  }
}
