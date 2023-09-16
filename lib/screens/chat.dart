import 'package:cxgenie/providers/virtual_agent_provider.dart';
import 'package:cxgenie/screens/contact_information.dart';
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
      Provider.of<VirtualAgentProvider>(context, listen: false)
          .getVirtualAgentDetail(widget.virtualAgentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VirtualAgentProvider>(builder: (context, value, child) {
      final virtualAgent = value.virtualAgent;
      String color = virtualAgent.themeColor.replaceAll("#", "0xff");
      final customer = value.customer;

      return SizedBox(
        width: (MediaQuery.of(context).size.width),
        height: (MediaQuery.of(context).size.height),
        child: SafeArea(
            child: (widget.userToken == "" || widget.userToken == null) &&
                    customer == null
                ? ContactInformation(
                    virtualAgentId: widget.virtualAgentId,
                    themeColor: Color(int.parse(color)),
                  )
                : Column(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(),
                      ),
                      const Row(
                        children: <Widget>[
                          Expanded(
                              flex: 1,
                              child: TextField(
                                decoration:
                                    InputDecoration(hintText: "Type message"),
                                textInputAction: TextInputAction.send,
                              ))
                        ],
                      )
                    ],
                  )),
      );
    });
  }
}
