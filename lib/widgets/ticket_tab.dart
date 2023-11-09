import 'package:cxgenie/enums/language.dart';
import 'package:cxgenie/widgets/ticket_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tab_bar/library.dart';

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
  _TicketTabState createState() => _TicketTabState();
}

class _TicketTabState extends State<TicketTab> {
  final int pageCount = 3;
  final PageController _controller = PageController(initialPage: 0);
  final CustomTabBarController _tabBarController = CustomTabBarController();

  @override
  void initState() {
    super.initState();
  }

  Widget getTabbarChild(BuildContext context, int index) {
    return TabBarItem(
      index: index,
      transform: ColorsTransform(
          highlightColor:
              Color(int.parse(widget.themeColor.replaceAll("#", "0xff"))),
          normalColor: const Color(0xff7D828B),
          builder: (context, color) {
            return Container(
              padding: const EdgeInsets.all(2),
              alignment: Alignment.center,
              constraints: const BoxConstraints(minWidth: 60),
              child: (Text(
                index == 0
                    ? 'Open'
                    : index == 1
                        ? 'Closed'
                        : 'All',
                style: TextStyle(fontSize: 14, color: color),
              )),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomTabBar(
            tabBarController: _tabBarController,
            height: 50,
            itemCount: pageCount,
            builder: getTabbarChild,
            indicator: LinearIndicator(
                color:
                    Color(int.parse(widget.themeColor.replaceAll("#", "0xff"))),
                bottom: 5),
            pageController: _controller,
          ),
          Expanded(
              child: PageView.builder(
                  controller: _controller,
                  itemCount: pageCount,
                  itemBuilder: (context, index) {
                    return TicketList(
                      workspaceId: widget.workspaceId,
                      themeColor: widget.themeColor,
                      customerId: widget.customerId,
                      language: widget.language,
                      showCreateButton: index != 1,
                      statuses: index == 0
                          ? ['OPEN', 'IN_PROGRESS']
                          : index == 1
                              ? ['SOLVED', 'CLOSED']
                              : [],
                    );
                  }))
        ],
      ),
    );
  }
}
