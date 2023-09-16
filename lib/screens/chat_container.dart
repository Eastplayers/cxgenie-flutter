import 'package:cxgenie/providers/chat_provider.dart';
import 'package:cxgenie/screens/chat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return ChangeNotifierProvider(
      create: (context) => ChatProvider(),
      child: Chat(virtualAgentId: widget.virtualAgentId),
    );
  }
}
