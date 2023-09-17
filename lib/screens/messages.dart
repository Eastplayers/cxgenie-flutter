import 'package:cxgenie/models/customer.dart';
import 'package:cxgenie/models/message.dart';
import 'package:cxgenie/models/virtual_agent.dart';
import 'package:cxgenie/providers/chat_provider.dart';
import 'package:cxgenie/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Messages extends StatefulWidget {
  const Messages(
      {Key? key, required this.customerId, required this.virtualAgentId})
      : super(key: key);

  final String customerId;
  final String virtualAgentId;

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final ChatService _chatService = ChatService();
  late IO.Socket socket;

  /// Send message
  void sendMessage(String content) async {
    await _chatService
        .sendMessage(widget.virtualAgentId, widget.customerId, content, []);
  }

  /// Connect to socket to receive messages in real-time
  void connectSocket() {
    socket = IO.io('https://api-staging.cxgenie.ai',
        IO.OptionBuilder().setTransports(['websocket']).build());
    socket.onConnect((_) {
      print('connect');
      socket.emit('msg', 'test');
    });
    socket.on('new_message', (data) {
      if (data['sender_id'] == widget.customerId ||
          data['receiver_id'] == widget.customerId) {
        final virtualAgent = data['chatbot'];
        final sender = data['sender'];
        final receiver = data['receiver'];
        Message newMessage = Message(
            id: data['id'],
            content: data['content'],
            receiverId: data['receiver_id'],
            type: data['type'],
            virtualAgentId: data['chatbot_id'],
            senderId: data['sender_id'],
            createdAt: data['created_at'],
            virtualAgent: virtualAgent == null
                ? null
                : VirtualAgent(
                    id: virtualAgent['id'],
                    name: virtualAgent['name'],
                    themeColor: virtualAgent['theme_color'],
                    createdAt: virtualAgent['created_at'],
                    updatedAt: virtualAgent['updated_at'],
                    workspaceId: virtualAgent['workspace_id'],
                  ),
            sender: sender == null
                ? null
                : Customer(
                    id: sender['id'],
                    name: sender['name'],
                    avatar: sender['avatar']),
            receiver: receiver == null
                ? null
                : Customer(
                    id: receiver['id'],
                    name: receiver['name'],
                    avatar: receiver['avatar']));

        Provider.of<ChatProvider>(context, listen: false)
            .addMessage(newMessage);
      }
    });
    socket.onDisconnect((_) => print('disconnect'));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ChatProvider>(context, listen: false)
          .getMessages(widget.customerId);
    });
    connectSocket();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(builder: (context, value, child) {
      return Container(
        width: (MediaQuery.of(context).size.width),
        height: (MediaQuery.of(context).size.height),
        color: Color(0xffF2F3F5),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: _buildMessageList(value.messages, value.virtualAgent),
            ),
            _buildComposer()
          ],
        ),
      );
    });
  }

  /// Build message list
  Widget _buildMessageList(List<Message> messages, VirtualAgent virtualAgent) {
    return ListView.builder(
        itemCount: messages.length,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        reverse: true,
        itemBuilder: (context, int index) {
          return _buildMessageItem(messages[index], virtualAgent);
        });
  }

  /// Build message item
  Widget _buildMessageItem(Message message, VirtualAgent virtualAgent) {
    String color = virtualAgent.themeColor.replaceAll("#", "0xff");
    var isMine = message.senderId == widget.customerId;
    DateTime createdAt = DateTime.parse("${message.createdAt}");
    var formatter = DateFormat("dd/MM/yy, hh:mm");

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: isMine ? Color(int.parse(color)) : Colors.white,
                borderRadius: BorderRadius.circular(8)),
            child: Text(
              message.content,
              style:
                  TextStyle(color: isMine ? Colors.white : Color(0xff2C2E33)),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            formatter.format(createdAt),
            style: const TextStyle(fontSize: 12, color: Color(0xffA3A9B3)),
          )
        ],
      ),
    );
  }

  /// Build composer
  Widget _buildComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: FormBuilderTextField(
                name: 'message',
                decoration: InputDecoration(hintText: "Type message"),
                textInputAction: TextInputAction.send,
              ))
        ],
      ),
    );
  }
}
