import 'package:cxgenie/providers/chat_provider.dart';
import 'package:cxgenie/screens/contact_information.dart';
import 'package:cxgenie/screens/messages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;

class Chat extends StatefulWidget {
  const Chat(
      {Key? key,
      required this.virtualAgentId,
      this.userToken,
      this.showChatWithAgent = false})
      : super(key: key);

  final String virtualAgentId;
  final String? userToken;
  final bool? showChatWithAgent;

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ChatProvider>(context, listen: false)
          .getVirtualAgentDetail(widget.virtualAgentId, widget.userToken);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(builder: (context, value, child) {
      final virtualAgent = value.virtualAgent;
      String color = virtualAgent.themeColor.replaceAll("#", "0xff");
      final customer = value.customer;

      return SizedBox(
          width: (MediaQuery.of(context).size.width),
          height: (MediaQuery.of(context).size.height),
          child: SafeArea(
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
                        virtualAgentId: widget.virtualAgentId,
                        themeColor: Color(int.parse(color)),
                      )
                    : Messages(
                        customerId: customer!.id,
                        virtualAgentId: widget.virtualAgentId,
                      ),
          ));
    });
  }
}
