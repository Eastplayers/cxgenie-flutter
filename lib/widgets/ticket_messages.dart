import 'package:cxgenie/enums/language.dart';
import 'package:cxgenie/models/message.dart';
import 'package:cxgenie/models/ticket.dart';
import 'package:cxgenie/providers/ticket_provider.dart';
import 'package:cxgenie/services/app_service.dart';
import 'package:cxgenie/widgets/icon.dart';
import 'package:cxgenie/widgets/ticket_message_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class TicketMessages extends StatefulWidget {
  const TicketMessages({
    Key? key,
    required this.ticketId,
    required this.workspaceId,
    required this.customerId,
    this.language = LanguageOptions.en,
    this.composerDisabled = false,
    this.themeColor = "#364DE7",
  }) : super(key: key);

  final String ticketId;
  final String workspaceId;
  final String customerId;
  final String themeColor;
  final LanguageOptions? language;
  final bool composerDisabled;

  @override
  TicketMessagesState createState() => TicketMessagesState();
}

class TicketMessagesState extends State<TicketMessages> {
  final AppService _service = AppService();
  late io.Socket socket;
  final TextEditingController textController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<MessageMedia> _uploadedFiles = [];
  bool _isSendingMessage = false;
  final ScrollController _controller = ScrollController();
  Ticket _ticket = Ticket(
    id: "",
    name: "",
    status: "",
    code: 0,
    createdAt: "",
    updatedAt: "",
    creatorId: "",
    autoReply: false,
    botId: "",
  );

  /// Send message
  void sendMessage(String content) async {
    if (textController.text.trim().isNotEmpty || _uploadedFiles.isNotEmpty) {
      Provider.of<TicketProvider>(context, listen: false)
          .updateSelectedTicketMessage(null);
      textController.clear();
      var cloneFiles = [..._uploadedFiles];
      setState(() {
        _uploadedFiles = [];
      });
      _controller.animateTo(_controller.position.minScrollExtent,
          duration: const Duration(seconds: 1), curve: Curves.easeInOut);
      DateTime now = DateTime.now();
      String isoDate = now.toIso8601String();
      var newMessage = <String, dynamic>{
        'workspace_id': widget.workspaceId,
        'content': content.trim(),
        'media': cloneFiles,
        'customer_id': widget.customerId,
        'sender_id': widget.customerId,
        'type': 'TEXT',
        'ticket_id': widget.ticketId,
      };
      socket.emit('message.ticket.create', newMessage);
      Message internalNewMessage = Message(
        type: "TEXT",
        content: content.trim(),
        media: cloneFiles,
        senderId: widget.customerId,
        createdAt: isoDate,
        id: isoDate,
      );
      Provider.of<TicketProvider>(context, listen: false)
          .addMessage(internalNewMessage);
      if (_ticket.botId != null && _ticket.autoReply == true) {
        _isSendingMessage = true;
      }
    }
  }

  /// Connect to socket to receive messages in real-time
  void connectSocket() {
    socket = io.io('https://api.cxgenie.ai', <String, dynamic>{
      'transports': ['websocket'],
      'forceNew': true,
    });
    socket.onConnect((_) {
      socket.emit('room.conversation.join', widget.customerId);
    });
    socket.on('is_typing', (isTyping) {
      _isSendingMessage = isTyping;
    });
    socket.on('new_message', (data) {
      if (data['receiver_id'] == widget.customerId &&
          data['ticket_id'] == widget.ticketId) {
        Provider.of<TicketProvider>(context, listen: false)
            .updateSelectedTicketMessage(null);
        _isSendingMessage = false;
        Message newMessage = Message.fromJson(data);

        Provider.of<TicketProvider>(context, listen: false)
            .addMessage(newMessage);
      }
    });
    socket.onDisconnect((_) {
      socket.emit('room.conversation.leave', widget.customerId);
    });
  }

  /// onImagePicketPressed
  void _onImageButtonPressed(
    ImageSource source, {
    required BuildContext context,
  }) async {
    if (context.mounted) {
      try {
        // final List<XFile> pickedFileList = await _picker.pickMultiImage(
        //     imageQuality: 70, maxWidth: 1000, maxHeight: 1000);
        final XFile? pickedFile = await _picker.pickImage(
            source: source, imageQuality: 70, maxWidth: 1000, maxHeight: 1000);
        // setState(() {
        //   _mediaFileList = pickedFileList;
        // });
        if (pickedFile != null) {
          var result = await _service.uploadFile(pickedFile);
          setState(() {
            _uploadedFiles = [..._uploadedFiles, MessageMedia(url: result)];
          });
        }
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }
  }

  void _getTicketDetail() async {
    var res = await _service.getTicketDetail(widget.ticketId);
    _ticket = res;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<TicketProvider>(context, listen: false)
          .getMessages(widget.ticketId);
    });
    connectSocket();
    _getTicketDetail();
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TicketProvider>(builder: (context, value, child) {
      return Container(
        width: (MediaQuery.of(context).size.width),
        height: (MediaQuery.of(context).size.height),
        color: const Color(0xffF2F3F5),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: value.isLoadingMessages
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xffD6DAE1),
                      ),
                    )
                  : _buildMessageList(value.messages, context),
            ),
            Container(
                width: (MediaQuery.of(context).size.width),
                height: _uploadedFiles.isNotEmpty ? 100 : 0,
                color: Colors.white,
                padding: const EdgeInsets.only(top: 6),
                child: _uploadedFiles.isNotEmpty
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _uploadedFiles.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 100,
                            height: 100,
                            color: Colors.white,
                            child: Stack(
                              children: [
                                Center(
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color(0xffD6DAE1),
                                        ),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Image.network(
                                      _uploadedFiles[index].url,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _uploadedFiles = _uploadedFiles
                                            .where((file) =>
                                                file.url !=
                                                _uploadedFiles[index].url)
                                            .toList();
                                      });
                                    },
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        })
                    : null),
            Container(
              child: _isSendingMessage
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 10,
                            height: 10,
                            child: CircularProgressIndicator(
                              color: Color(0xffA3A9B3),
                              strokeWidth: 2,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            widget.language == LanguageOptions.en
                                ? "${_ticket.bot?.name} is typing..."
                                : "${_ticket.bot?.name} đang nhập...",
                            style: const TextStyle(
                                color: Color(0xff7D828B), fontSize: 12),
                            textAlign: TextAlign.left,
                          )
                        ],
                      ),
                    )
                  : null,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: const Color.fromRGBO(255, 255, 255, 1),
              child: widget.composerDisabled
                  ? Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            widget.language == LanguageOptions.en
                                ? "You can no longer send message to this ticket"
                                : "Bạn không thể gửi tin nhắn cho thẻ hỗ trợ này nữa",
                            style: const TextStyle(color: Color(0xffA3A9B3)),
                          ),
                        )
                      ],
                    )
                  : Row(
                      children: <Widget>[
                        GestureDetector(
                          child: SvgPicture.string(
                            imageIcon,
                            width: 24,
                            height: 24,
                          ),
                          onTap: () {
                            showCupertinoModalPopup(
                                context: context,
                                builder: (BuildContext context) {
                                  return CupertinoActionSheet(
                                    title: Text(
                                        widget.language == LanguageOptions.en
                                            ? 'Choose media'
                                            : 'Chọn hình ảnh'),
                                    actions: <Widget>[
                                      CupertinoActionSheetAction(
                                        child: Text(
                                          widget.language == LanguageOptions.en
                                              ? 'Choose from gallery'
                                              : 'Chọn ảnh từ thư viện',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          FocusScope.of(context).unfocus();
                                          _onImageButtonPressed(
                                              ImageSource.gallery,
                                              context: context);
                                        },
                                      ),
                                      // CupertinoActionSheetAction(
                                      //   child: const Text(
                                      //     'Take picture from camera',
                                      //     style: TextStyle(fontSize: 16),
                                      //   ),
                                      //   onPressed: () {},
                                      // )
                                    ],
                                    cancelButton: CupertinoActionSheetAction(
                                      isDestructiveAction: true,
                                      onPressed: () {
                                        Navigator.pop(context, 'Cancel');
                                      },
                                      child: Text(
                                        widget.language == LanguageOptions.en
                                            ? 'Cancel'
                                            : 'Huỷ bỏ',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  );
                                });
                          },
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            autofocus: true,
                            controller: textController,
                            cursorColor: Color(int.parse(
                                widget.themeColor.replaceAll("#", "0xff"))),
                            decoration: InputDecoration(
                              hintText: widget.language == LanguageOptions.en
                                  ? "Type message"
                                  : "Nhập tin nhắn",
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(fontSize: 14),
                            textInputAction: TextInputAction.send,
                            onSubmitted: (value) => sendMessage(value),
                            onEditingComplete: () {},
                          ),
                        ),
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
            )
          ],
        ),
      );
    });
  }

  /// Build message list
  Widget _buildMessageList(List<Message> messages, BuildContext context) {
    return ListView.builder(
      controller: _controller,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: messages.length,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      reverse: true,
      itemBuilder: (context, int index) {
        return TicketMessageItem(
          message: messages[index],
          index: index,
          messages: messages,
          customerId: widget.customerId,
          themeColor: widget.themeColor,
        );
      },
    );
  }
}
