import 'package:cxgenie/helpers/date.dart';
import 'package:cxgenie/models/message.dart';
import 'package:cxgenie/providers/ticket_provider.dart';
import 'package:cxgenie/widgets/icon.dart';
import 'package:cxgenie/widgets/linkify.dart';
import 'package:cxgenie/widgets/reaction_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:url_launcher/url_launcher.dart';

class TicketMessageItem extends StatefulWidget {
  final Message message;
  final int index;
  final List<Message> messages;
  final String customerId;
  final String themeColor;

  const TicketMessageItem({
    Key? key,
    required this.message,
    required this.index,
    required this.messages,
    required this.customerId,
    required this.themeColor,
  }) : super(key: key);

  @override
  TicketMessageItemState createState() => TicketMessageItemState();
}

class TicketMessageItemState extends State<TicketMessageItem> {
  late io.Socket socket;

  /// Connect to socket to receive messages in real-time
  void connectSocket() {
    socket = io.io('https://api.cxgenie.ai', <String, dynamic>{
      'transports': ['websocket'],
      'forceNew': true,
    });

    socket.on('message.reaction.created', (data) {
      if (data['message']['id'] == widget.message.id) {
        MessageReactions reactions =
            MessageReactions.fromJson(data['message']['reactions']);
        if (reactions != null) {
          Provider.of<TicketProvider>(context, listen: false)
              .updateMessageReactions("${widget.message.id}", reactions);
        }
        // setState(() {
        //   reactions = MessageReactions.fromJson(data['message']['reactions']);
        // });
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
    Provider.of<TicketProvider>(context, listen: false)
        .updateSelectedTicketMessage(null);
  }

  @override
  void initState() {
    super.initState();
    connectSocket();
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
    MessageReactions? reactions =
        widget.message.reactions ?? MessageReactions.fromJson({});

    return Portal(
      child: Consumer<TicketProvider>(builder: (context, value, child) {
        bool showReactions = value.selectedTicketMessageId == widget.message.id;

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
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
                  crossAxisAlignment: isMine
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
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
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    Provider.of<TicketProvider>(context,
                                            listen: false)
                                        .updateSelectedTicketMessage(null);
                                  },
                                  onLongPress: () {
                                    if (!isMine) {
                                      Provider.of<TicketProvider>(context,
                                              listen: false)
                                          .updateSelectedTicketMessage(
                                              widget.message.id);
                                      // _showReactionModal(
                                      //     context, isMine, color, createdAt);
                                    }
                                  },
                                  child: PortalTarget(
                                    visible: showReactions,
                                    closeDuration: kThemeAnimationDuration,
                                    anchor: const Aligned(
                                      follower: Alignment(-0.2, 1),
                                      target: Alignment(1, 1),
                                    ),
                                    portalFollower:
                                        TweenAnimationBuilder<double>(
                                      duration: kThemeAnimationDuration,
                                      curve: Curves.easeOut,
                                      tween: Tween(
                                          begin: 0, end: showReactions ? 1 : 0),
                                      builder: (context, progress, child) {
                                        return Transform(
                                          transform: Matrix4.translationValues(
                                              0, (1 - progress) * 50, 0),
                                          child: Opacity(
                                            opacity: progress,
                                            child: child,
                                          ),
                                        );
                                      },
                                      child: Center(
                                        child: ReactionIndicator(
                                          child: Container(
                                            width: 56,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 4,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(100)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                ReactionButton(
                                                  reaction:
                                                      reactions!.like != null
                                                          ? likedIcon
                                                          : likeIcon,
                                                  reacted:
                                                      reactions!.like != null,
                                                  reactMessage: () =>
                                                      reactMessage('like'),
                                                  bgColor: reactions!.like !=
                                                          null
                                                      ? const Color(0xff3BA55C)
                                                      : Colors.white,
                                                ),
                                                const SizedBox(width: 8),
                                                ReactionButton(
                                                  reaction:
                                                      reactions!.dislike != null
                                                          ? dislikedIcon
                                                          : dislikeIcon,
                                                  reacted: reactions!.dislike !=
                                                      null,
                                                  reactMessage: () =>
                                                      reactMessage('dislike'),
                                                  bgColor: reactions!.dislike !=
                                                          null
                                                      ? const Color(0xffFC8B23)
                                                      : Colors.white,
                                                ),
                                                // Add more ReactionButton widgets as needed
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    child: Container(
                                      constraints: BoxConstraints(
                                        maxWidth: (MediaQuery.of(context)
                                                .size
                                                .width) -
                                            180,
                                      ),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: isMine
                                            ? Color(int.parse(color))
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RegExp('<[^>]*>',
                                                      multiLine: true,
                                                      caseSensitive: false)
                                                  .hasMatch(
                                                      "${widget.message.content?.trim()}")
                                              ? Html(
                                                  data:
                                                      """<div class="container">${widget.message.content}<div/>""",
                                                  onLinkTap: (url, attributes,
                                                      element) async {
                                                    if (await canLaunchUrl(
                                                        Uri.parse(url!))) {
                                                      await launchUrl(
                                                          Uri.parse(url));
                                                    }
                                                  },
                                                  style: {
                                                    'div.container': Style(
                                                      color: isMine
                                                          ? Colors.white
                                                          : const Color(
                                                              0xff2C2E33),
                                                      fontSize: FontSize.medium,
                                                      padding:
                                                          HtmlPaddings.all(0),
                                                      margin: Margins.all(0),
                                                      alignment:
                                                          Alignment.topLeft,
                                                    ),
                                                    'a': Style(
                                                      color: isMine
                                                          ? Colors.white
                                                          : Color(
                                                              int.parse(color)),
                                                      fontSize: FontSize.medium,
                                                    )
                                                  },
                                                )
                                              : Container(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Linkify(
                                                    onOpen: (link) async {
                                                      if (await canLaunchUrl(
                                                          Uri.parse(
                                                              link.url))) {
                                                        await launchUrl(
                                                            Uri.parse(
                                                                link.url));
                                                      }
                                                    },
                                                    text: Bidi.stripHtmlIfNeeded(
                                                            "${widget.message.content?.trim()}")
                                                        .trim(),
                                                    style: TextStyle(
                                                      color: isMine
                                                          ? Colors.white
                                                          : const Color(
                                                              0xff2C2E33),
                                                      fontSize: 14,
                                                    ),
                                                    linkStyle: TextStyle(
                                                      color: isMine
                                                          ? Colors.white
                                                          : Color(
                                                              int.parse(color),
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                              left: 8,
                                              right: 8,
                                              bottom: 4,
                                            ),
                                            child: Text(
                                              isToday(createdAt)
                                                  ? "Hôm nay, ${formatter.format(createdAt)}"
                                                  : formatter.format(createdAt),
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: isMine
                                                    ? Colors.white
                                                        .withOpacity(0.7)
                                                    : const Color(0xffA3A9B3),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                if (!showReactions &&
                                    (!isMine &&
                                            (reactions.like != null &&
                                                reactions.like!.isNotEmpty) ||
                                        (reactions.dislike != null &&
                                            reactions.dislike!.isNotEmpty)))
                                  Positioned(
                                    right: isMine ? null : -16,
                                    bottom: 0,
                                    left: isMine ? -16 : null,
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: reactions!.like != null
                                            ? const Color(0xff3BA55C)
                                            : const Color(0xffFC8B23),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
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
                                                shadowColor:
                                                    const Color.fromRGBO(
                                                        23, 24, 26, 0.5),
                                                backgroundColor:
                                                    Colors.transparent,
                                                content: GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: SizedBox(
                                                    width:
                                                        (MediaQuery.of(context)
                                                            .size
                                                            .width),
                                                    height:
                                                        (MediaQuery.of(context)
                                                            .size
                                                            .height),
                                                    child: Stack(
                                                      children: [
                                                        Center(
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        32),
                                                            child:
                                                                Image.network(
                                                              mediaItem.url,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          top: 0,
                                                          right: 0,
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Container(
                                                              width: 32,
                                                              height: 32,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: const Color
                                                                    .fromRGBO(0,
                                                                    0, 0, 0.7),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            16),
                                                              ),
                                                              child: const Icon(
                                                                Icons.close,
                                                                color: Colors
                                                                    .white,
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
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                            isToday(createdAt)
                                ? "Hôm nay, ${formatter.format(createdAt)}"
                                : formatter.format(createdAt),
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
      }),
    );
  }

  // void _showReactionModal(
  //     BuildContext context, bool isMine, String color, DateTime createdAt) {
  //   var formatter = DateFormat(isToday(createdAt) ? "hh:mm" : "dd/MM/yy hh:mm");

  //   showDialog(
  //     context: context,
  //     useRootNavigator: false,
  //     useSafeArea: false,
  //     builder: (context) => SafeArea(
  //       child: Padding(
  //         padding: isMine
  //             ? const EdgeInsets.only(right: 12)
  //             : const EdgeInsets.only(left: 48),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           crossAxisAlignment:
  //               isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
  //           children: [
  //             IgnorePointer(
  //               child: Container(
  //                 constraints: BoxConstraints(
  //                   maxWidth: (MediaQuery.of(context).size.width) - 180,
  //                 ),
  //                 padding: const EdgeInsets.all(10),
  //                 decoration: BoxDecoration(
  //                   color: isMine ? Color(int.parse(color)) : Colors.white,
  //                   borderRadius: BorderRadius.circular(8),
  //                 ),
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       "${widget.message.content?.trim()}",
  //                       style: TextStyle(
  //                         color:
  //                             isMine ? Colors.white : const Color(0xff2C2E33),
  //                         fontSize: 14,
  //                       ),
  //                     ),
  //                     const SizedBox(height: 4),
  //                     SizedBox(
  //                       child: Text(
  //                         formatter.format(createdAt),
  //                         textAlign: TextAlign.left,
  //                         style: TextStyle(
  //                           fontSize: 11,
  //                           color: isMine
  //                               ? Colors.white.withOpacity(0.7)
  //                               : const Color(0xffA3A9B3),
  //                         ),
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 10),
  //             LayoutBuilder(
  //               builder: (context, constraints) {
  //                 return Align(
  //                   alignment: Alignment(
  //                     calculateReactionsHorizontalAlignment(
  //                       widget.message.sender,
  //                       widget.message,
  //                       constraints,
  //                       14,
  //                       Orientation.portrait,
  //                     ),
  //                     0,
  //                   ),
  //                   child: Container(
  //                     width: 68,
  //                     height: 26,
  //                     padding: const EdgeInsets.symmetric(
  //                         horizontal: 8, vertical: 4),
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(40),
  //                       color: Colors.white,
  //                     ),
  //                     child: Row(
  //                       children: [
  //                         ReactionButton(
  //                             reaction: likeIcon, reactMessage: reactMessage),
  //                         const SizedBox(width: 12),
  //                         ReactionButton(
  //                             reaction: dislikeIcon, reactMessage: reactMessage)
  //                       ],
  //                     ),
  //                   ),
  //                 );
  //               },
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

class ReactionButton extends StatelessWidget {
  final String reaction;
  final Function reactMessage;
  final Color? bgColor;
  final bool reacted;

  const ReactionButton({
    Key? key,
    required this.reaction,
    required this.reactMessage,
    this.bgColor,
    this.reacted = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        reactMessage();
      },
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: bgColor ?? Colors.white,
          borderRadius: BorderRadius.circular(100.0),
        ),
        child: Center(
          child: SvgPicture.string(
            reaction,
            width: reacted ? 12 : 20,
            height: reacted ? 12 : 20,
          ),
        ),
      ),
    );
  }
}

class Barrier extends StatelessWidget {
  const Barrier({
    Key? key,
    required this.onClose,
    required this.visible,
    required this.child,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onClose;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    return PortalTarget(
      visible: visible,
      closeDuration: kThemeAnimationDuration,
      portalFollower: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onClose,
        child: TweenAnimationBuilder<Color>(
          duration: kThemeAnimationDuration,
          tween: ColorTween(
            begin: Colors.transparent,
            end: visible ? Colors.black54 : Colors.transparent,
          ),
          builder: (context, color, child) {
            return ColoredBox(color: color);
          },
        ),
      ),
      child: child,
    );
  }
}

/// Non-nullable version of ColorTween.
class ColorTween extends Tween<Color> {
  ColorTween({required Color begin, required Color end})
      : super(begin: begin, end: end);

  @override
  Color lerp(double t) => Color.lerp(begin, end, t)!;
}
