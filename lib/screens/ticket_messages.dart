import 'package:cxgenie/enums/language.dart';
import 'package:cxgenie/models/customer.dart';
import 'package:cxgenie/models/message.dart';
import 'package:cxgenie/models/virtual_agent.dart';
import 'package:cxgenie/providers/ticket_provider.dart';
import 'package:cxgenie/services/chat_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
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

const String supportIcon = '''
  <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
    <path fill-rule="evenodd" clip-rule="evenodd" d="M12.9312 22.5031H13.5212V22.4931C13.9513 22.4931 14.3712 22.3631 14.7212 22.1131C15.0612 21.8731 15.3113 21.5531 15.4613 21.1731H15.7712C17.7113 21.1731 19.3612 19.6531 19.5513 17.7131C20.1213 17.4531 20.6012 17.0331 20.9513 16.5031C21.3013 15.9531 21.4912 15.3231 21.4912 14.6731V10.9331C21.4912 8.40312 20.5013 6.02312 18.7113 4.23312C16.9213 2.44314 14.5412 1.45312 12.0112 1.45312C6.78125 1.45312 2.53125 5.70312 2.53125 10.9431V14.6831C2.53125 15.5731 2.88125 16.4231 3.51125 17.0531C4.14125 17.6831 4.98125 18.0331 5.88125 18.0331H6.05125C6.55125 18.0331 7.01125 17.8431 7.36125 17.4931C7.71125 17.1431 7.90125 16.6831 7.90125 16.1831V12.2231C7.90125 11.7231 7.71125 11.2631 7.36125 10.9131C7.01125 10.5631 6.54125 10.3731 6.05125 10.3731H5.88125C5.24125 10.3731 4.62125 10.5631 4.08125 10.9131C4.09125 6.55312 7.66125 3.00312 12.0212 3.00312C16.3813 3.00312 19.9412 6.55312 19.9513 10.9131C19.4212 10.5631 18.8013 10.3731 18.1512 10.3731H17.9812C17.4913 10.3731 17.0113 10.5731 16.6713 10.9131C16.3212 11.2631 16.1313 11.7331 16.1313 12.2231V16.1831C16.1313 16.6831 16.3212 17.1431 16.6713 17.4931C17.0013 17.8231 17.4612 18.0231 17.9312 18.0331C17.7912 18.4731 17.5212 18.8631 17.1613 19.1431C16.7712 19.4531 16.2712 19.6231 15.7712 19.6231H15.4613C15.3113 19.2431 15.0512 18.9231 14.7212 18.6831C14.3712 18.4331 13.9513 18.3031 13.5212 18.3031H12.9312C11.7712 18.3031 10.8313 19.2431 10.8313 20.4031C10.8313 21.5631 11.7712 22.5031 12.9312 22.5031ZM12.5413 20.0231C12.6512 19.9231 12.7912 19.8631 12.9312 19.8631H13.5312C13.6812 19.8631 13.8212 19.9231 13.9213 20.0231C14.0213 20.1331 14.0813 20.2631 14.0813 20.4131C14.0813 20.5631 14.0213 20.7031 13.9213 20.8031C13.8113 20.9031 13.6812 20.9631 13.5312 20.9631H12.9312C12.7812 20.9631 12.6413 20.9031 12.5413 20.8031C12.4412 20.6931 12.3813 20.5631 12.3813 20.4131C12.3813 20.2631 12.4412 20.1231 12.5413 20.0231ZM17.7712 12.0231C17.8313 11.9631 17.9012 11.9331 17.9812 11.9331L17.9712 11.9231H18.1412C19.1413 11.9231 19.9513 12.7331 19.9513 13.7331V14.6831C19.9513 15.6831 19.1512 16.4931 18.1512 16.4931H17.9812C17.9012 16.4931 17.8313 16.4631 17.7712 16.4031C17.7112 16.3431 17.6812 16.2731 17.6812 16.1931V12.2331C17.6812 12.1531 17.7112 12.0831 17.7712 12.0231ZM4.61125 12.4531C4.95125 12.1131 5.41125 11.9231 5.89125 11.9231H6.06125C6.14125 11.9231 6.21125 11.9531 6.27125 12.0131C6.33125 12.0731 6.36125 12.1431 6.36125 12.2231V16.1831C6.36125 16.2631 6.33125 16.3331 6.27125 16.3931C6.22125 16.4531 6.14125 16.4831 6.06125 16.4831H5.89125C5.41125 16.4831 4.95125 16.2931 4.61125 15.9531C4.27125 15.6131 4.08125 15.1531 4.08125 14.6731V13.7331C4.08125 13.2431 4.27125 12.7931 4.61125 12.4531Z" fill="#DBDEE3"/>
    <path d="M9.20125 15.3331C8.82125 15.1531 8.73125 14.6731 8.96125 14.3231C9.19125 13.9831 9.64125 13.8931 10.0213 14.0631C11.2813 14.6231 12.7512 14.6231 14.0112 14.0631C14.3812 13.8931 14.8413 13.9831 15.0713 14.3231C15.3013 14.6731 15.2113 15.1431 14.8313 15.3331C13.9513 15.7631 12.9913 15.9731 12.0213 15.9731C11.0513 15.9731 10.0913 15.7631 9.21125 15.3331H9.20125Z" fill="#DBDEE3"/>
  </svg>
''';

class TicketMessages extends StatefulWidget {
  const TicketMessages(
      {Key? key,
      required this.ticketId,
      required this.workspaceId,
      required this.chatUserId,
      this.language = LanguageOptions.en,
      this.composerDisabled = false,
      this.themeColor = "#364DE7"})
      : super(key: key);

  final String ticketId;
  final String workspaceId;
  final String chatUserId;
  final String themeColor;
  final LanguageOptions? language;
  final bool composerDisabled;

  @override
  _TicketMessagesState createState() => _TicketMessagesState();
}

class _TicketMessagesState extends State<TicketMessages> {
  final ChatService _chatService = ChatService();
  late IO.Socket socket;
  final TextEditingController textController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<MessageMedia> _uploadedFiles = [];
  bool _isSendingMessage = false;
  final ScrollController _controller = ScrollController();

  /// Send message
  void sendMessage(String content) async {
    if (textController.text.isNotEmpty || _uploadedFiles.isNotEmpty) {
      _isSendingMessage = true;
      textController.clear();
      var cloneFiles = [..._uploadedFiles];
      setState(() {
        _uploadedFiles = [];
      });
      _controller.animateTo(_controller.position.minScrollExtent,
          duration: const Duration(seconds: 1), curve: Curves.easeInOut);
      await _chatService.sendTicketMessage(widget.workspaceId, widget.ticketId,
          widget.chatUserId, content, cloneFiles);
      _isSendingMessage = false;
    }
  }

  /// Connect to socket to receive messages in real-time
  void connectSocket() {
    socket = IO.io('https://api-staging.cxgenie.ai', <String, dynamic>{
      'transports': ['websocket'],
      'forceNew': true,
    });
    socket.onConnect((_) {
      print("Socket connected");
    });
    socket.on('new_message', (data) {
      if ((data['sender_id'] == widget.chatUserId ||
              data['receiver_id'] == widget.chatUserId) &&
          data['ticket_id'] == widget.ticketId) {
        final virtualAgent = data['bot'];
        final sender = data['sender'];
        final receiver = data['receiver'];
        final media = data['media'] == null ? null : data['media'] as List;
        Message newMessage = Message(
            id: data['id'],
            content: data['content'],
            receiverId: data['receiver_id'],
            type: data['type'],
            virtualAgentId: data['bot_id'],
            senderId: data['sender_id'],
            createdAt: data['created_at'],
            media: media == null
                ? []
                : media.map((mediaItem) {
                    return MessageMedia(url: mediaItem['url']);
                  }).toList(),
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

        Provider.of<TicketProvider>(context, listen: false)
            .addMessage(newMessage);
      }
    });
    socket.onDisconnect((_) => print('Socket disconnected'));
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
          var result = await _chatService.uploadFile(pickedFile);
          setState(() {
            _uploadedFiles = [..._uploadedFiles, MessageMedia(url: result)];
          });
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<TicketProvider>(context, listen: false)
          .getMessages(widget.ticketId);
    });
    connectSocket();
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
                    : _buildMessageList(value.messages),
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
                                          borderRadius:
                                              BorderRadius.circular(8)),
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
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: const Icon(
                                            Icons.close,
                                            size: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ))
                                ],
                              ),
                            );
                          })
                      : null),
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
                              style: TextStyle(color: Color(0xffA3A9B3)),
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
                                        title: Text(widget.language ==
                                                LanguageOptions.en
                                            ? 'Choose media'
                                            : 'Chọn hình ảnh'),
                                        actions: <Widget>[
                                          CupertinoActionSheetAction(
                                            child: Text(
                                              widget.language ==
                                                      LanguageOptions.en
                                                  ? 'Choose from gallery'
                                                  : 'Chọn ảnh từ thư viện',
                                              style:
                                                  const TextStyle(fontSize: 16),
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
                                        cancelButton:
                                            CupertinoActionSheetAction(
                                                isDestructiveAction: true,
                                                onPressed: () {
                                                  Navigator.pop(
                                                      context, 'Cancel');
                                                },
                                                child: Text(
                                                  widget.language ==
                                                          LanguageOptions.en
                                                      ? 'Cancel'
                                                      : 'Huỷ bỏ',
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                )));
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
                                  hintText:
                                      widget.language == LanguageOptions.en
                                          ? "Type message"
                                          : "Nhập tin nhắn",
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
                            child: _isSendingMessage
                                ? SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Color(int.parse(widget.themeColor
                                          .replaceAll("#", "0xff"))),
                                    ),
                                  )
                                : SvgPicture.string(
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
          ));
    });
  }

  /// Build message list
  Widget _buildMessageList(List<Message> messages) {
    return ListView.builder(
        controller: _controller,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: messages.length,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        reverse: true,
        itemBuilder: (context, int index) {
          return _buildMessageItem(messages[index], index, messages);
        });
  }

  /// Build message item
  Widget _buildMessageItem(Message message, int index, List<Message> messages) {
    String color = widget.themeColor.replaceAll("#", "0xff");
    String foregroundColor = widget.themeColor.replaceAll("#", "0x22");
    bool isMine = message.senderId == widget.chatUserId;
    DateTime createdAt = DateTime.parse("${message.createdAt}").toLocal();
    var formatter = DateFormat("dd/MM/yy, hh:mm");
    // bool isSameSender = _checkIsSameSender(index, message, messages);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: !isMine
                ? message.sender?.avatar == null &&
                        message.virtualAgent?.avatar == null
                    ? Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Color(int.parse(foregroundColor))),
                        child: Center(
                          child: Text(
                            "${message.sender?.name[0].toUpperCase() ?? message.virtualAgent?.name[0].toUpperCase()}",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color(int.parse(color))),
                          ),
                        ),
                      )
                    : ClipOval(
                        child: Image.network(
                          "${message.sender?.avatar ?? message.virtualAgent?.avatar}",
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
                child: message.content == null || message.content!.isEmpty
                    ? null
                    : Container(
                        constraints: BoxConstraints(
                            maxWidth:
                                (MediaQuery.of(context).size.width) - 100),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color:
                                isMine ? Color(int.parse(color)) : Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          "${message.content}",
                          style: TextStyle(
                              color: isMine
                                  ? Colors.white
                                  : const Color(0xff2C2E33),
                              fontSize: 14),
                        ),
                      ),
              ),
              Container(
                decoration: const BoxDecoration(),
                child: message.media != null && message.media!.isNotEmpty
                    ? Column(
                        children: message.media!
                            .map((mediaItem) => GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            contentPadding:
                                                const EdgeInsets.all(0),
                                            insetPadding:
                                                const EdgeInsets.all(16),
                                            elevation: 0,
                                            shadowColor: const Color.fromRGBO(
                                                23, 24, 26, 0.5),
                                            backgroundColor: Colors.transparent,
                                            content: GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: SizedBox(
                                                width: (MediaQuery.of(context)
                                                    .size
                                                    .width),
                                                height: (MediaQuery.of(context)
                                                    .size
                                                    .height),
                                                child: Stack(
                                                  children: [
                                                    Center(
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 32),
                                                        child: Image.network(
                                                          mediaItem.url,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: 0,
                                                      right: 0,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Container(
                                                            width: 32,
                                                            height: 32,
                                                            decoration: BoxDecoration(
                                                                color: const Color
                                                                    .fromRGBO(0,
                                                                    0, 0, 0.7),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            16)),
                                                            child: const Icon(
                                                              Icons.close,
                                                              color:
                                                                  Colors.white,
                                                            )),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  child: Container(
                                    clipBehavior: Clip.hardEdge,
                                    margin: const EdgeInsets.only(top: 4),
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.white,
                                        border: Border.all(
                                            color: const Color(0xffD6DAE1),
                                            width: 1)),
                                    child: Image.network(
                                      mediaItem.url,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ))
                            .toList(),
                      )
                    : null,
              ),
              const SizedBox(
                height: 4,
              ),
              SizedBox(
                child: Text(
                  formatter.format(createdAt),
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xffA3A9B3)),
                ),
              )
            ],
          ))
        ],
      ),
    );
  }
}
