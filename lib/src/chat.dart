import 'package:flutter/material.dart';

class ChatContainer extends StatefulWidget {
  const ChatContainer(
      {Key? key,
      required this.virtualAgentId,
      this.userToken,
      this.showChatWithAgent = false})
      : super(key: key);

  final String virtualAgentId;
  final String? userToken;
  final bool? showChatWithAgent;

  @override
  _ChatContainerState createState() => _ChatContainerState();
}

class _ChatContainerState extends State<ChatContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width),
      height: (MediaQuery.of(context).size.height),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Container(
            child: const Row(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(hintText: "Type message"),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
