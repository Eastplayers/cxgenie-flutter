import 'package:cxgenie/enums/language.dart';
import 'package:cxgenie/models/ticket_category.dart';
import 'package:cxgenie/providers/ticket_provider.dart';
import 'package:cxgenie/services/app_service.dart';
import 'package:cxgenie/widgets/ticket_messages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xffD6DAE1),
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
                                      width:
                                          (MediaQuery.of(context).size.width),
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
                                                  child:
                                                      const Icon(Icons.close),
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
                                            customerId: "${widget.customerId}",
                                            workspaceId: widget.workspaceId,
                                            language: widget.language,
                                            composerDisabled:
                                                ticket.status == 'CLOSED' ||
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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

  @override
  void initState() {
    super.initState();
    getTicketCategories();
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
                        onPressed: () {
                          widget.createTicket(
                              widget.workspaceId,
                              textController.text,
                              widget.customerId,
                              selectedSubCategory.isNotEmpty
                                  ? selectedSubCategory
                                  : selectedCategory,
                              widget.statuses);
                          textController.clear();
                          Navigator.pop(context, 'Cancel');
                        },
                        child: Text(
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
