import 'package:cxgenie/enums/language.dart';
import 'package:cxgenie/widgets/ticket_list.dart';
import 'package:flutter/material.dart';

class TicketTab extends StatefulWidget {
  const TicketTab(
      {Key? key,
      required this.workspaceId,
      this.customerId,
      this.userToken,
      this.language = LanguageOptions.en,
      required this.themeColor})
      : super(key: key);

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
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            TabBar(
              tabs: [
                Tab(
                  text: widget.language == LanguageOptions.vi
                      ? 'Đang mở'
                      : 'Open',
                ),
                Tab(
                  text: widget.language == LanguageOptions.vi
                      ? 'Đã đóng'
                      : 'Closed',
                ),
                Tab(
                  text:
                      widget.language == LanguageOptions.vi ? 'Tất cả' : 'All',
                ),
              ],
              unselectedLabelColor: const Color(0xff7D828B),
              labelColor:
                  Color(int.parse(widget.themeColor.replaceAll("#", "0xff"))),
              indicatorColor:
                  Color(int.parse(widget.themeColor.replaceAll("#", "0xff"))),
            ),
            const Divider(
              height: 1,
              color: Color(0xffD6DAE1),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  TicketList(
                    index: 0,
                    workspaceId: widget.workspaceId,
                    themeColor: widget.themeColor,
                    customerId: widget.customerId,
                    language: widget.language,
                    showCreateButton: true,
                    statuses: const ['OPEN', 'IN_PROGRESS'],
                  ),
                  TicketList(
                    index: 1,
                    workspaceId: widget.workspaceId,
                    themeColor: widget.themeColor,
                    customerId: widget.customerId,
                    language: widget.language,
                    showCreateButton: false,
                    statuses: const ['SOLVED', 'CLOSED'],
                  ),
                  TicketList(
                    index: 2,
                    workspaceId: widget.workspaceId,
                    themeColor: widget.themeColor,
                    customerId: widget.customerId,
                    language: widget.language,
                    showCreateButton: true,
                    statuses: const ['OPEN', 'IN_PROGRESS', 'SOLVED', 'CLOSED'],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
