import 'package:cxgenie/enums/language.dart';
import 'package:cxgenie/providers/app_provider.dart';
import 'package:cxgenie/widgets/contact_information.dart';
import 'package:cxgenie/widgets/messages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Chat extends StatefulWidget {
  const Chat({
    Key? key,
    required this.botId,
    this.userToken,
    this.language = LanguageOptions.en,
  }) : super(key: key);

  final String botId;
  final String? userToken;
  final LanguageOptions? language;

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<AppProvider>(context, listen: false)
          .getBotDetail(widget.botId, widget.userToken);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, value, child) {
      final virtualAgent = value.bot;
      String color = virtualAgent.themeColor.replaceAll("#", "0xff");
      final customer = value.customer;

      return SizedBox(
          width: (MediaQuery.of(context).size.width),
          height: (MediaQuery.of(context).size.height),
          child: Container(
            child: value.isLoading
                ? const SizedBox(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xffD6DAE1),
                      ),
                    ),
                  )
                : customer == null
                    ? ContactInformation(
                        botId: widget.botId,
                        themeColor: Color(int.parse(color)),
                        language: widget.language,
                      )
                    : Stack(
                        children: [
                          Messages(
                            workspaceId: virtualAgent.workspaceId,
                            customerId: customer.id,
                            botId: widget.botId,
                            themeColor: virtualAgent.themeColor,
                            language: widget.language,
                          ),
                        ],
                      ),
          ));
    });
  }
}
