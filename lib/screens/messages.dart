import 'package:cxgenie/models/customer.dart';
import 'package:cxgenie/models/message.dart';
import 'package:cxgenie/models/virtual_agent.dart';
import 'package:cxgenie/providers/chat_provider.dart';
import 'package:cxgenie/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

const String sendIcon = '''
  <svg width="25" height="24" viewBox="0 0 25 24" fill="none" xmlns="http://www.w3.org/2000/svg">
    <path d="M5.91 21.75C4.79 21.75 4.08 21.37 3.63 20.92C2.75 20.04 2.13 18.17 4.11 14.2L4.98 12.47C5.09 12.24 5.09 11.76 4.98 11.53L4.11 9.79999C2.12 5.82999 2.75 3.94999 3.63 3.07999C4.5 2.19999 6.38 1.56999 10.34 3.55999L18.9 7.83999C21.03 8.89999 22.2 10.38 22.2 12C22.2 13.62 21.03 15.1 18.91 16.16L10.35 20.44C8.41 21.41 6.97 21.75 5.91 21.75ZM5.91 3.74999C5.37 3.74999 4.95 3.87999 4.69 4.13999C3.96 4.85999 4.25 6.72999 5.45 9.11999L6.32 10.86C6.64 11.51 6.64 12.49 6.32 13.14L5.45 14.87C4.25 17.27 3.96 19.13 4.69 19.85C5.41 20.58 7.28 20.29 9.68 19.09L18.24 14.81C19.81 14.03 20.7 13 20.7 11.99C20.7 10.98 19.8 9.94999 18.23 9.16999L9.67 4.89999C8.15 4.13999 6.84 3.74999 5.91 3.74999Z" fill="#A3A9B3"/>
    <path d="M11.34 12.75H5.94C5.53 12.75 5.19 12.41 5.19 12C5.19 11.59 5.53 11.25 5.94 11.25H11.34C11.75 11.25 12.09 11.59 12.09 12C12.09 12.41 11.75 12.75 11.34 12.75Z" fill="#A3A9B3"/>
  </svg>
''';

const String imageIcon = '''
  <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
    <path d="M18.3608 22.7499H5.59084C4.07084 22.7499 2.68084 21.9799 1.88084 20.6799C1.08084 19.3799 1.01084 17.7999 1.69084 16.4299L3.41084 12.9799C3.97084 11.8599 4.87084 11.1599 5.88084 11.0499C6.89084 10.9399 7.92084 11.4399 8.70084 12.4099L8.92084 12.6899C9.36084 13.2299 9.87084 13.5199 10.3708 13.4699C10.8708 13.4299 11.3308 13.0699 11.6708 12.4599L13.5608 9.04993C14.3408 7.63993 15.3808 6.90993 16.5108 6.95993C17.6308 7.01993 18.5908 7.85993 19.2308 9.33993L22.3608 16.6499C22.9408 17.9999 22.8008 19.5399 21.9908 20.7699C21.1908 22.0199 19.8308 22.7499 18.3608 22.7499ZM6.16084 12.5499C6.12084 12.5499 6.08084 12.5499 6.04084 12.5599C5.54084 12.6099 5.08084 13.0099 4.75084 13.6599L3.03084 17.1099C2.58084 17.9999 2.63084 19.0499 3.15084 19.8999C3.67084 20.7499 4.59084 21.2599 5.59084 21.2599H18.3508C19.3308 21.2599 20.2008 20.7899 20.7408 19.9699C21.2808 19.1499 21.3708 18.1699 20.9808 17.2699L17.8508 9.95993C17.4708 9.05993 16.9408 8.50993 16.4308 8.48993C15.9608 8.45993 15.3508 8.95993 14.8708 9.80993L12.9808 13.2199C12.4008 14.2599 11.4908 14.9099 10.5008 14.9999C9.51084 15.0799 8.50084 14.5999 7.75084 13.6599L7.53084 13.3799C7.11084 12.8299 6.63084 12.5499 6.16084 12.5499Z" fill="#7D828B"/>
    <path d="M6.9707 8.75C4.9107 8.75 3.2207 7.07 3.2207 5C3.2207 2.93 4.9007 1.25 6.9707 1.25C9.0407 1.25 10.7207 2.93 10.7207 5C10.7207 7.07 9.0407 8.75 6.9707 8.75ZM6.9707 2.75C5.7307 2.75 4.7207 3.76 4.7207 5C4.7207 6.24 5.7307 7.25 6.9707 7.25C8.2107 7.25 9.2207 6.24 9.2207 5C9.2207 3.76 8.2107 2.75 6.9707 2.75Z" fill="#7D828B"/>
  </svg>
''';

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
  final TextEditingController textController = TextEditingController();

  /// Send message
  void sendMessage(String content) async {
    textController.clear();
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
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: messages.length,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        reverse: true,
        itemBuilder: (context, int index) {
          return _buildMessageItem(messages[index], virtualAgent);
        });
  }

  /// Build message item
  Widget _buildMessageItem(Message message, VirtualAgent virtualAgent) {
    String color = virtualAgent.themeColor.replaceAll("#", "0xff");
    String foregroundColor = virtualAgent.themeColor.replaceAll("#", "0x22");
    var isMine = message.senderId == widget.customerId;
    DateTime createdAt = DateTime.parse("${message.createdAt}");
    var formatter = DateFormat("dd/MM/yy, hh:mm");

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: !isMine
                ? virtualAgent.avatar == null
                    ? Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Color(int.parse(foregroundColor))),
                        child: Center(
                          child: Text(
                            virtualAgent.name[0].toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color(int.parse(color))),
                          ),
                        ),
                      )
                    : ClipOval(
                        child: Image.network(
                          "${virtualAgent.avatar}",
                          width: 32,
                          height: 32,
                          fit: BoxFit.cover,
                        ),
                      )
                : null,
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment:
                isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(
                    maxWidth: (MediaQuery.of(context).size.width) - 100),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: isMine ? Color(int.parse(color)) : Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                  message.content,
                  style: TextStyle(
                      color: isMine ? Colors.white : Color(0xff2C2E33),
                      fontSize: 14),
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
          ))
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
          GestureDetector(
            child: SvgPicture.string(
              imageIcon,
              width: 24,
              height: 24,
            ),
            onTap: () {},
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
              flex: 1,
              child: TextField(
                autofocus: true,
                controller: textController,
                decoration: const InputDecoration(
                  hintText: "Type message",
                  border: InputBorder.none,
                ),
                style: const TextStyle(fontSize: 14),
                textInputAction: TextInputAction.send,
                onSubmitted: (value) => sendMessage(value),
                onEditingComplete: () {},
              )),
          const SizedBox(
            width: 16,
          ),
          GestureDetector(
            child: SvgPicture.string(
              sendIcon,
              width: 24,
              height: 24,
            ),
            onTap: () {
              sendMessage(textController.text);
            },
          )
        ],
      ),
    );
  }
}
