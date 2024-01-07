import 'package:cxgenie/helpers/date.dart';
import 'package:cxgenie/models/message.dart';
import 'package:cxgenie/widgets/icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MessageItem extends StatefulWidget {
  final Message message;
  final int index;
  final List<Message> messages;
  final String customerId;
  final String themeColor;

  MessageItem({
    required this.message,
    required this.index,
    required this.messages,
    required this.customerId,
    required this.themeColor,
  });

  @override
  _MessageItemState createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  bool showReactions = false;
  late IO.Socket socket;
  MessageReactions? reactions;

  /// Connect to socket to receive messages in real-time
  void connectSocket() {
    socket = IO.io('https://api-staging.cxgenie.ai', <String, dynamic>{
      'transports': ['websocket'],
      'forceNew': true,
    });

    socket.on('message.reaction.created', (data) {
      print(data['message']['reactions']);
      if (data['message']['id'] == widget.message.id) {
        setState(() {
          reactions = MessageReactions.fromJson(data['message']['reactions']);
        });
      }
    });
  }

  void reactMessage(type) {
    var payload = <String, dynamic>{
      'message_id': widget.message.id,
      'customer_id': widget.customerId,
      'value': type,
    };
    socket.emit('message.reaction.create', payload);
    setState(() {
      showReactions = false;
    });
  }

  @override
  void initState() {
    super.initState();
    connectSocket();
    setState(() {
      reactions = widget.message.reactions;
    });
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String color = widget.themeColor.replaceAll("#", "0xff");
    String foregroundColor = widget.themeColor.replaceAll("#", "0x22");
    bool isMine = widget.message.senderId == widget.customerId;
    DateTime createdAt =
        DateTime.parse("${widget.message.createdAt}").toLocal();
    var formatter = DateFormat(isToday(createdAt) ? "hh:mm" : "dd/MM/yy hh:mm");

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: !isMine
                ? widget.message.sender?.avatar == null &&
                        widget.message.bot?.avatar == null
                    ? Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Color(
                            int.parse(foregroundColor),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "${widget.message.sender?.name[0].toUpperCase() ?? widget.message.bot?.name[0].toUpperCase()}",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Color(
                                int.parse(color),
                              ),
                            ),
                          ),
                        ),
                      )
                    : ClipOval(
                        child: Image.network(
                          "${widget.message.sender?.avatar ?? widget.message.bot?.avatar}",
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
                  child: widget.message.content == null ||
                          widget.message.content!.isEmpty
                      ? null
                      : Stack(
                          // mainAxisAlignment: isMine
                          //     ? MainAxisAlignment.end
                          //     : MainAxisAlignment.start,
                          // crossAxisAlignment: CrossAxisAlignment.end,
                          clipBehavior: Clip.none,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  showReactions = false;
                                });
                              },
                              onLongPress: () {
                                if (!isMine) {
                                  setState(() {
                                    showReactions = true;
                                  });
                                }
                              },
                              onLongPressMoveUpdate: (details) {
                                // Handle long press move update
                              },
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      (MediaQuery.of(context).size.width) - 180,
                                ),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isMine
                                      ? Color(int.parse(color))
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${widget.message.content?.trim()}",
                                      style: TextStyle(
                                        color: isMine
                                            ? Colors.white
                                            : const Color(0xff2C2E33),
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    SizedBox(
                                      child: Text(
                                        formatter.format(createdAt),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: isMine
                                              ? Colors.white.withOpacity(0.7)
                                              : Color(0xffA3A9B3),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            if (!isMine &&
                                    !showReactions &&
                                    reactions != null &&
                                    (reactions!.like != null &&
                                        reactions!.like!.isNotEmpty) ||
                                (reactions!.dislike != null &&
                                    reactions!.dislike!.isNotEmpty))
                              Positioned(
                                right: isMine ? null : -16,
                                bottom: 0,
                                left: isMine ? -16 : null,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                      color: reactions!.like != null
                                          ? Color(0xff3BA55C)
                                          : Color(0xffFC8B23),
                                      borderRadius: BorderRadius.circular(100)),
                                  child: Center(
                                    child: Container(
                                      child: reactions!.like != null
                                          ? SvgPicture.string(
                                              likedIcon,
                                              width: 12,
                                              height: 12,
                                            )
                                          : SvgPicture.string(
                                              dislikedIcon,
                                              width: 12,
                                              height: 12,
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            if (showReactions)
                              Positioned(
                                // right: isMine ? null : -80,
                                bottom: 0,
                                // left: isMine ? -80 : null,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(100)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ReactionButton(
                                        reaction: likeIcon,
                                        reactMessage: () =>
                                            reactMessage('like'),
                                      ),
                                      const SizedBox(width: 12),
                                      ReactionButton(
                                        reaction: dislikeIcon,
                                        reactMessage: () =>
                                            reactMessage('dislike'),
                                      ),
                                      // Add more ReactionButton widgets as needed
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                ),
                Container(
                  decoration: const BoxDecoration(),
                  child: widget.message.media != null &&
                          widget.message.media!.isNotEmpty
                      ? Column(
                          children: widget.message.media!
                              .map(
                                (mediaItem) => GestureDetector(
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
                                                          decoration:
                                                              BoxDecoration(
                                                            color: const Color
                                                                .fromRGBO(
                                                                0, 0, 0, 0.7),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16),
                                                          ),
                                                          child: const Icon(
                                                            Icons.close,
                                                            color: Colors.white,
                                                          ),
                                                        ),
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
                                        width: 1,
                                      ),
                                    ),
                                    child: Image.network(
                                      mediaItem.url,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        )
                      : null,
                ),
                if (widget.message.content?.trim() == '')
                  Column(
                    children: [
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        formatter.format(createdAt),
                        style: const TextStyle(
                            fontSize: 11, color: Color(0xffA3A9B3)),
                      )
                    ],
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ReactionButton extends StatelessWidget {
  final String reaction;
  final Function reactMessage;

  ReactionButton({required this.reaction, required this.reactMessage});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('Tab reaction');
        reactMessage();
      },
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100.0),
        ),
        child: Center(
          child: SvgPicture.string(
            reaction,
            width: 20,
            height: 20,
          ),
        ),
      ),
    );
  }
}
