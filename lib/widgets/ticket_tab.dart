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
  TicketTabState createState() => TicketTabState();
}

class TicketTabState extends State<TicketTab> {
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
              padding: const EdgeInsets.all(12),
              alignment: Alignment.center,
              constraints: const BoxConstraints(minWidth: 60),
              child: (Text(
                index == 0
                    ? widget.language == LanguageOptions.vi
                        ? 'Đang mở'
                        : 'Open'
                    : index == 1
                        ? widget.language == LanguageOptions.vi
                            ? 'Đã đóng'
                            : 'Closed'
                        : widget.language == LanguageOptions.vi
                            ? 'Tất cả'
                            : 'All',
                style: TextStyle(fontSize: 14, color: color),
              )),
            );
          }),
    );
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
                    text: widget.language == LanguageOptions.vi
                        ? 'Tất cả'
                        : 'All',
                  ),
                ],
                unselectedLabelColor: Color(0xff7D828B),
                labelColor:
                    Color(int.parse(widget.themeColor.replaceAll("#", "0xff"))),
                indicatorColor:
                    Color(int.parse(widget.themeColor.replaceAll("#", "0xff"))),
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
                      statuses: const [
                        'OPEN',
                        'IN_PROGRESS',
                        'SOLVED',
                        'CLOSED'
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          // body: Column(
          //   children: [
          //     Container(
          //       padding: const EdgeInsets.symmetric(horizontal: 16),
          //       child: CustomTabBar(
          //         tabBarController: _tabBarController,
          //         height: 45,
          //         itemCount: pageCount,
          //         builder: getTabbarChild,
          //         indicator: LinearIndicator(
          //             color: Color(
          //                 int.parse(widget.themeColor.replaceAll("#", "0xff"))),
          //             bottom: 0),
          //         pageController: _controller,
          //       ),
          //     ),
          //     const Divider(
          //       height: 1,
          //       color: Color(0xffD6DAE1),
          //     ),
          //     Expanded(
          //         child: PageView.builder(
          //             controller: _controller,
          //             itemCount: pageCount,
          //             itemBuilder: (context, index) {
          //               return TicketList(
          //                 index: index,
          //                 workspaceId: widget.workspaceId,
          //                 themeColor: widget.themeColor,
          //                 customerId: widget.customerId,
          //                 language: widget.language,
          //                 showCreateButton: index != 1,
          //                 statuses: index == 0
          //                     ? ['OPEN', 'IN_PROGRESS']
          //                     : index == 1
          //                         ? ['SOLVED', 'CLOSED']
          //                         : ['OPEN', 'IN_PROGRESS', 'SOLVED', 'CLOSED'],
          //               );
          //             }))
          //   ],
          // ),
        ));
  }
}
