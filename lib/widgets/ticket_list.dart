import 'dart:ffi';

import 'package:cxgenie/enums/language.dart';
import 'package:cxgenie/models/ticket_category.dart';
import 'package:cxgenie/providers/ticket_provider.dart';
import 'package:cxgenie/services/app_service.dart';
import 'package:cxgenie/widgets/ticket_messages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

const String emptyImg = '''
  <svg width="89" height="89" viewBox="0 0 89 89" fill="none" xmlns="http://www.w3.org/2000/svg">
    <g id="Frame">
    <g id="Group">
    <g id="Exp-2.-F">
    <path id="Vector" d="M72 49.4736H17V74.9276C17 76.1418 17.7961 77.2129 18.9594 77.5621C24.4855 79.219 40.0257 83.8816 43.7094 84.9871C44.225 85.1411 44.775 85.1411 45.2906 84.9871C48.9743 83.8816 64.5145 79.219 70.0406 77.5621C71.2039 77.2129 72 76.1418 72 74.9276C72 68.5531 72 49.4736 72 49.4736Z" fill="#F2F3F5"/>
    <path id="Vector_2" d="M72.0014 49.4736H44.5014C44.5014 49.4736 44.2346 85.1026 44.5014 85.1026C44.7681 85.1026 45.0335 85.0641 45.292 84.9871C48.9756 83.8816 64.5159 79.219 70.042 77.5621C71.2052 77.2129 72.0014 76.1418 72.0014 74.9276C72.0014 68.5531 72.0014 49.4736 72.0014 49.4736Z" fill="#C4C9D2"/>
    <path id="Vector_3" d="M44.5008 58.396L17.0008 49.4736C17.0008 49.4736 12.1787 56.6236 10.0227 59.8191C9.78071 60.178 9.72159 60.6276 9.86184 61.036C10.0035 61.4444 10.3266 61.762 10.7377 61.8968C15.9613 63.5935 31.4246 68.6178 35.4808 69.935C36.0625 70.1248 36.7005 69.9061 37.0442 69.3988C38.8881 66.6776 44.5008 58.396 44.5008 58.396Z" fill="#D6DAE1"/>
    <path id="Vector_4" d="M72 49.4736L44.5 58.396C44.5 58.396 50.1128 66.6776 51.9566 69.3988C52.3004 69.9061 52.9384 70.1248 53.52 69.935C57.5763 68.6178 73.0395 63.5935 78.2631 61.8968C78.6743 61.762 78.9974 61.4444 79.139 61.036C79.2793 60.6276 79.2201 60.178 78.9781 59.8191C76.8221 56.6236 72 49.4736 72 49.4736Z" fill="#D6DAE1"/>
    <path id="Vector_5" d="M37.845 30.7311C37.5012 30.2265 36.8646 30.0079 36.283 30.1976C32.2295 31.5135 16.7621 36.5391 11.5385 38.2373C11.1274 38.3706 10.8029 38.6883 10.6626 39.0966C10.5224 39.505 10.5815 39.956 10.8235 40.3135C12.809 43.2588 17.0014 49.4738 17.0014 49.4738L44.5014 40.5211C44.5014 40.5211 39.5624 33.257 37.845 30.7311Z" fill="#F2F3F5"/>
    <path id="Vector_6" d="M78.1779 40.3135C78.4199 39.956 78.479 39.505 78.3388 39.0966C78.1985 38.6883 77.874 38.3706 77.4629 38.2373C72.2393 36.5391 56.7719 31.5135 52.7184 30.1976C52.1368 30.0079 51.5001 30.2265 51.1564 30.7311C49.439 33.257 44.5 40.5211 44.5 40.5211L72 49.4738C72 49.4738 76.1924 43.2588 78.1779 40.3135Z" fill="#D6DAE1"/>
    <path id="Vector_7" d="M72 49.4736L44.5 40.521L17 49.4736L44.5 58.396L72 49.4736Z" fill="#F2F3F5"/>
    <path id="Vector_8" d="M44.5 58.396V40.521L17 49.4736L44.5 58.396Z" fill="#C4C9D2"/>
    <g id="Group_2">
    <path id="Vector_9" d="M38.9769 44.4701C38.4049 44.0961 37.8892 43.6959 37.4314 43.2766C36.8731 42.7637 36.0027 42.8008 35.4885 43.3604C34.9756 43.9187 35.0127 44.7891 35.5724 45.3019C36.1347 45.8189 36.7686 46.3112 37.4726 46.7718C38.1079 47.1871 38.9604 47.0083 39.3756 46.3731C39.7909 45.7378 39.6121 44.8853 38.9769 44.4701Z" fill="#A3A9B3"/>
    <path id="Vector_10" d="M34.6925 40.2457C34.2841 39.6916 33.939 39.1347 33.6557 38.5778C33.312 37.9013 32.4828 37.6318 31.8063 37.9756C31.1298 38.3193 30.8603 39.1485 31.2041 39.825C31.5533 40.5097 31.9768 41.1958 32.4787 41.8765C32.9283 42.487 33.7891 42.6176 34.401 42.168C35.0115 41.717 35.1421 40.8562 34.6925 40.2457Z" fill="#A3A9B3"/>
    <path id="Vector_11" d="M32.682 34.6347C32.6958 34.0806 32.7769 33.5429 32.9254 33.0273C33.1344 32.2986 32.7123 31.5354 31.9822 31.3264C31.2534 31.1174 30.4903 31.5396 30.2813 32.2697C30.0709 33.0067 29.9527 33.7753 29.932 34.5659C29.9142 35.3249 30.5137 35.9561 31.2727 35.9739C32.0317 35.9932 32.6628 35.3937 32.682 34.6347Z" fill="#A3A9B3"/>
    <path id="Vector_12" d="M34.7972 30.042C35.1506 29.7147 35.5466 29.4122 35.9797 29.1386C36.6218 28.733 36.8143 27.8832 36.4101 27.2425C36.0045 26.6003 35.1547 26.4078 34.5126 26.8121C33.931 27.1792 33.403 27.5848 32.9286 28.0248C32.3717 28.5405 32.3387 29.4108 32.8543 29.9677C33.37 30.5246 34.2403 30.5576 34.7972 30.042Z" fill="#A3A9B3"/>
    <path id="Vector_13" d="M39.9104 27.6701C40.602 27.5422 41.3349 27.4597 42.1076 27.4281C42.8666 27.3951 43.4551 26.7529 43.4235 25.9953C43.3919 25.2377 42.7498 24.6478 41.9908 24.6794C41.0833 24.7179 40.2225 24.8156 39.4099 24.9654C38.6646 25.1043 38.1696 25.8221 38.3085 26.5673C38.446 27.3139 39.1638 27.8076 39.9104 27.6701Z" fill="#A3A9B3"/>
    <path id="Vector_14" d="M47.0774 27.5889C48.2502 27.6027 49.342 27.5614 50.3554 27.472C51.1116 27.4047 51.6712 26.7364 51.6039 25.9802C51.5365 25.2253 50.8682 24.6657 50.112 24.733C49.1839 24.8142 48.1842 24.8527 47.109 24.8389C46.35 24.8307 45.7271 25.4398 45.7189 26.1974C45.7092 26.9564 46.3184 27.5807 47.0774 27.5889Z" fill="#A3A9B3"/>
    <path id="Vector_15" d="M54.8743 26.6293C56.2356 26.2127 57.3851 25.6792 58.3476 25.0673C58.987 24.6589 59.1767 23.8092 58.7683 23.1684C58.3613 22.529 57.5102 22.3393 56.8695 22.7477C56.0953 23.2399 55.1672 23.6634 54.07 23.9989C53.3453 24.2217 52.9356 24.9903 53.1584 25.7163C53.3797 26.4423 54.1497 26.8507 54.8743 26.6293Z" fill="#A3A9B3"/>
    <path id="Vector_16" d="M61.8733 21.2185C62.5223 19.8765 62.7711 18.4575 62.7079 17.0894C62.6721 16.3304 62.0273 15.7446 61.2696 15.7804C60.512 15.8161 59.9249 16.4596 59.9606 17.2172C60.0046 18.1467 59.8369 19.1106 59.3969 20.0222C59.0669 20.7056 59.3529 21.5292 60.0363 21.8592C60.7196 22.1892 61.5433 21.9019 61.8733 21.2185Z" fill="#A3A9B3"/>
    <path id="Vector_17" d="M60.9982 12.2276C59.9958 10.8732 58.6359 9.92993 57.1537 9.62606C56.4098 9.47481 55.6824 9.95331 55.5298 10.6972C55.3786 11.4411 55.8584 12.1684 56.6009 12.3211C57.4562 12.4957 58.2097 13.0828 58.7886 13.8652C59.2409 14.4743 60.1031 14.6022 60.7122 14.1512C61.3227 13.6988 61.4506 12.8367 60.9982 12.2276Z" fill="#A3A9B3"/>
    </g>
    <path id="Vector_18" d="M43.0332 9.89284C44.521 1.46822 57.4143 2.01272 49.9082 9.89284H43.0332Z" fill="#F2F3F5"/>
    <path id="Vector_19" d="M43.0332 12.0269C44.521 20.4501 57.4143 19.907 49.9082 12.0269H43.0332Z" fill="#F2F3F5"/>
    <path id="Vector_20" d="M42.9102 12.3486H52.1172C52.8762 12.3486 53.4922 11.7326 53.4922 10.9736C53.4922 10.2146 52.8762 9.59863 52.1172 9.59863H42.9102C42.1525 9.59863 41.5352 10.2146 41.5352 10.9736C41.5352 11.7326 42.1525 12.3486 42.9102 12.3486Z" fill="#C4C9D2"/>
    </g>
    </g>
    </g>
  </svg>
''';

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

Map<String, Map<LanguageOptions, String>> nameMap = {
  'OPEN': {LanguageOptions.en: 'Open', LanguageOptions.vi: 'Chờ xử lý'},
  'IN_PROGRESS': {
    LanguageOptions.en: 'In progress',
    LanguageOptions.vi: 'Đang xử lý'
  },
  'SOLVED': {LanguageOptions.en: 'Solved', LanguageOptions.vi: 'Đã xử lý'},
  'MERGED': {LanguageOptions.en: 'Merged', LanguageOptions.vi: 'Đã gộp'},
  'CLOSED': {LanguageOptions.en: 'Closed', LanguageOptions.vi: 'Đã đóng'},
};

class TicketList extends StatefulWidget {
  const TicketList({
    Key? key,
    required this.index,
    required this.workspaceId,
    this.customerId,
    this.userToken,
    this.language = LanguageOptions.en,
    required this.themeColor,
    this.showCreateButton = true,
    this.statuses = const ['OPEN', 'IN_PROGRESS'],
  }) : super(key: key);

  final int index;
  final String workspaceId;
  final String? customerId;
  final String? userToken;
  final String themeColor;
  final LanguageOptions? language;
  final bool? showCreateButton;
  final List<String> statuses;

  @override
  TicketListState createState() => TicketListState();
}

class TicketListState extends State<TicketList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<TicketProvider>(context, listen: false).getTickets(
          "${widget.customerId}", widget.workspaceId, widget.statuses);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TicketProvider>(builder: (context, value, child) {
      String color = widget.themeColor.replaceAll("#", "0xff");

      return Scaffold(
        floatingActionButton: widget.showCreateButton == false
            ? null
            : FloatingActionButton(
                onPressed: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return DynamicHeightDialog(
                        language: widget.language,
                        workspaceId: widget.workspaceId,
                        customerId: "${widget.customerId}",
                        color: Color(int.parse(color)),
                        statuses: widget.statuses,
                        createTicket: value.createTicket,
                      );
                    },
                  );
                },
                backgroundColor: Color(int.parse(color)),
                elevation: 0,
                child: const Icon(Icons.add),
              ),
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          color: Color(int.parse(color)),
          onRefresh: _pullRefresh,
          child: value.isTicketListLoading == true
              ? Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 80),
                    child: const Column(
                      children: [
                        CircularProgressIndicator(
                          color: Color(0xffD6DAE1),
                        )
                      ],
                    ),
                  ),
                )
              : value.tickets.isEmpty
                  ? Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Column(
                          children: [
                            SvgPicture.string(
                              emptyImg,
                              width: 88,
                              height: 88,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              widget.language == LanguageOptions.en
                                  ? "Your tickets will appear here"
                                  : "Thẻ hỗ trợ của bạn sẽ xuất hiện ở đây",
                              style: const TextStyle(color: Color(0xff7D828B)),
                            )
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.only(
                        left: 12,
                        right: 12,
                        top: 6,
                        bottom: widget.index == 1 ? 6 : 120,
                      ),
                      itemCount: value.tickets.length,
                      separatorBuilder: (context, index) {
                        return const Divider(
                          color: Color(0xffD6DAE1),
                        );
                      },
                      itemBuilder: (context, index) {
                        var ticket = value.tickets[index];

                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: GestureDetector(
                            onTap: () {
                              showCupertinoModalPopup(
                                  context: context,
                                  builder: (content) {
                                    return ChangeNotifierProvider(
                                      create: (context) => TicketProvider(),
                                      child: Scaffold(
                                        body: Container(
                                          width: (MediaQuery.of(context)
                                              .size
                                              .width),
                                          height: (MediaQuery.of(context)
                                              .size
                                              .height),
                                          color: Colors.white,
                                          child: SafeArea(
                                              child: Column(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 16),
                                                color: Colors.white,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                        child: Text(
                                                      ticket.name,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    )),
                                                    const SizedBox(
                                                      width: 12,
                                                    ),
                                                    GestureDetector(
                                                      child: const Icon(
                                                          Icons.close),
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
                                                customerId:
                                                    "${widget.customerId}",
                                                workspaceId: widget.workspaceId,
                                                language: widget.language,
                                                composerDisabled: ticket
                                                            .status ==
                                                        'CLOSED' ||
                                                    ticket.status == 'MERGED' ||
                                                    ticket.status == 'SOLVED',
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
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "#${ticket.code}",
                                          style: const TextStyle(
                                              color: Color(0xff7D828B),
                                              fontSize: 14),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              color: colorMap[ticket.status]
                                                  ?['background']),
                                          child: Text(
                                            "${nameMap[ticket.status]?[widget.language]}",
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
                      }),
        ),
      );
    });
  }

  Future<void> _pullRefresh() async {
    Provider.of<TicketProvider>(context, listen: false).getTickets(
        "${widget.customerId}", widget.workspaceId, widget.statuses);
    await Future.delayed(const Duration(seconds: 1));
  }
}

class DynamicHeightDialog extends StatefulWidget {
  const DynamicHeightDialog({
    Key? key,
    required this.language,
    required this.workspaceId,
    required this.customerId,
    required this.statuses,
    required this.color,
    required this.createTicket,
  }) : super(key: key);

  final LanguageOptions? language;
  final String workspaceId;
  final String customerId;
  final Color color;
  final List<String> statuses;
  final Function createTicket;

  @override
  DynamicHeightDialogState createState() => DynamicHeightDialogState();
}

class DynamicHeightDialogState extends State<DynamicHeightDialog> {
  final AppService _service = AppService();
  final TextEditingController textController = TextEditingController();
  String selectedCategory = '';
  String selectedSubCategory = '';
  List<TicketCategory> categories = [];
  List<TicketCategory> subCategories = [];
  bool isCreating = false;
  late IO.Socket socket;

  void connectSocket() {
    socket = IO.io('https://api-staging.cxgenie.ai', <String, dynamic>{
      'transports': ['websocket'],
      'forceNew': true,
    });
  }

  @override
  void initState() {
    super.initState();
    getTicketCategories();
    connectSocket();
  }

  void getTicketCategories() async {
    final response = await _service.getTicketCategories(widget.workspaceId);
    setState(() {
      categories = response;
    });
  }

  void getTicketSubCategories(String parentId) async {
    if (parentId.isNotEmpty) {
      final response =
          await _service.getTicketSubCategories(widget.workspaceId, parentId);
      setState(() {
        subCategories = response;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      elevation: 0,
      shadowColor: const Color.fromRGBO(23, 24, 26, 0.5),
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      content: Container(
        width: (MediaQuery.of(context).size.width),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.language == LanguageOptions.en
                          ? 'Create ticket'
                          : 'Tạo thẻ hỗ trợ',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
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
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: categories.isNotEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.language == LanguageOptions.en
                                      ? 'Select category *'
                                      : 'Chọn mục *',
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                DropdownButtonFormField<String>(
                                  items: categories
                                      .map<DropdownMenuItem<String>>(
                                          (TicketCategory category) {
                                    return DropdownMenuItem<String>(
                                      value: category.id,
                                      child: Text(category.name),
                                    );
                                  }).toList(),
                                  onChanged: (String? v) {
                                    setState(() {
                                      selectedCategory = v!;
                                      selectedSubCategory = "";
                                    });
                                    getTicketSubCategories("$v");
                                  },
                                  borderRadius: BorderRadius.circular(8),
                                  elevation: 1,
                                  style: const TextStyle(
                                      fontSize: 14, color: Color(0xff2C2E33)),
                                  decoration: InputDecoration(
                                      hintText:
                                          widget.language == LanguageOptions.en
                                              ? 'Select category'
                                              : 'Chọn mục',
                                      hintStyle: const TextStyle(
                                        color: Color(0xffA3A9B3),
                                        fontSize: 14,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 0),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                            color: widget.color, width: 1.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                            color: Color(0xffD6DAE1),
                                            width: 1.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                            color: Color(0xffED4245),
                                            width: 1.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                            color: Color(0xffED4245),
                                            width: 1.0),
                                      )),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                              ],
                            )
                          : null,
                    ),
                    Container(
                      child: subCategories.isNotEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.language == LanguageOptions.en
                                      ? 'Select sub-category *'
                                      : 'Chọn mục con *',
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  items: subCategories
                                      .map<DropdownMenuItem<String>>(
                                          (TicketCategory category) {
                                    return DropdownMenuItem<String>(
                                      value: category.id,
                                      child: Text(category.name),
                                    );
                                  }).toList(),
                                  onChanged: (String? v) {
                                    // This is called when the user selects an item.
                                    setState(() {
                                      selectedSubCategory = v!;
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(8),
                                  elevation: 1,
                                  style: const TextStyle(
                                      fontSize: 14, color: Color(0xff2C2E33)),
                                  decoration: InputDecoration(
                                      hintText:
                                          widget.language == LanguageOptions.en
                                              ? 'Select sub-category'
                                              : 'Chọn mục con',
                                      hintStyle: const TextStyle(
                                        color: Color(0xffA3A9B3),
                                        fontSize: 14,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 0),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                            color: widget.color, width: 1.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                            color: Color(0xffD6DAE1),
                                            width: 1.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                            color: Color(0xffED4245),
                                            width: 1.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                            color: Color(0xffED4245),
                                            width: 1.0),
                                      )),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                              ],
                            )
                          : null,
                    ),
                    Text(
                      widget.language == LanguageOptions.en
                          ? 'What issue do you want us to support? *'
                          : 'Bạn muốn chúng tôi hỗ trợ vấn đề gì? *',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    TextField(
                      controller: textController,
                      autofocus: true,
                      maxLines: 6,
                      cursorColor: widget.color,
                      decoration: InputDecoration(
                        hintText: widget.language == LanguageOptions.en
                            ? "Type support detail"
                            : "Nhập nội dung cần hỗ trợ",
                        hintStyle: const TextStyle(color: Color(0xffA3A9B3)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(8),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(color: widget.color, width: 1.0),
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
              ),
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
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                        onPressed: () {
                          textController.clear();
                          Navigator.pop(context, 'Cancel');
                        },
                        child: Text(
                          widget.language == LanguageOptions.en
                              ? 'Cancel'
                              : 'Huỷ bỏ',
                          style: const TextStyle(
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
                          backgroundColor: widget.color,
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: isCreating
                            ? null
                            : () async {
                                if (!isCreating) {
                                  setState(() {
                                    isCreating = true;
                                  });
                                  final createdTicket =
                                      await widget.createTicket(
                                          widget.workspaceId,
                                          textController.text,
                                          widget.customerId,
                                          selectedSubCategory.isNotEmpty
                                              ? selectedSubCategory
                                              : selectedCategory,
                                          widget.statuses);
                                  print(createdTicket.id);
                                  var newMessage = <String, dynamic>{
                                    'workspace_id': widget.workspaceId,
                                    'content': textController.text,
                                    'media': [],
                                    'customer_id': widget.customerId,
                                    'sender_id': widget.customerId,
                                    'type': 'TEXT',
                                    'ticket_id': createdTicket.id,
                                  };
                                  socket.emit(
                                      'message.ticket.create', newMessage);
                                  textController.clear();
                                  setState(() {
                                    isCreating = false;
                                  });
                                  Navigator.pop(context, 'Cancel');
                                }
                              },
                        child: isCreating
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : Text(
                                widget.language == LanguageOptions.en
                                    ? 'Create ticket'
                                    : 'Tạo thẻ hỗ trợ',
                                style: const TextStyle(
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
      ),
    );
  }
}
