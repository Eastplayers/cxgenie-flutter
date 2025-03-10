import 'dart:async';

import 'package:cxgenie/enums/language.dart';
import 'package:cxgenie/helpers/date.dart';
import 'package:cxgenie/models/block_action.dart';
import 'package:cxgenie/models/bot.dart';
import 'package:cxgenie/models/message.dart';
import 'package:cxgenie/providers/app_provider.dart';
import 'package:cxgenie/widgets/icon.dart';
import 'package:cxgenie/widgets/message_actions.dart';
import 'package:cxgenie/widgets/message_content_renderer.dart';
import 'package:cxgenie/widgets/message_feedback.dart';
import 'package:cxgenie/widgets/message_link_preview.dart';
import 'package:cxgenie/widgets/message_media.dart';
import 'package:cxgenie/widgets/message_quote.dart';
import 'package:cxgenie/widgets/reaction_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:uuid/uuid.dart';

class MessageItem extends StatefulWidget {
  final Message message;
  final int index;
  final List<Message> messages;
  final String customerId;
  final String themeColor;
  final Bot bot;
  final LanguageOptions? language;
  final bool isLastMessage;

  const MessageItem({
    Key? key,
    required this.message,
    required this.index,
    required this.messages,
    required this.customerId,
    required this.themeColor,
    required this.bot,
    this.isLastMessage = false,
    this.language = LanguageOptions.en,
  }) : super(key: key);

  @override
  MessageItemState createState() => MessageItemState();
}

class MessageItemState extends State<MessageItem> {
  late io.Socket socket;

  /// Connect to socket to receive messages in real-time
  void connectSocket() {
    socket = io.io('https://api.cxgenie.ai', <String, dynamic>{
      'transports': ['websocket'],
      'forceNew': true,
    });
  }

  void reactMessage(type) {
    var payload = <String, dynamic>{
      'message_id': widget.message.id,
      'customer_id': widget.customerId,
      'value': type,
    };
    socket.emit('message.reaction.create', payload);
    Provider.of<AppProvider>(context, listen: false)
        .updateSelectedTicketMessage(null);
  }

  void sendMessage(BlockAction? action, [bool isLink = false]) async {
    if (action != null) {
      Provider.of<AppProvider>(context, listen: false)
          .updateSelectedTicketMessage(null);

      DateTime now = DateTime.now();
      String isoDate = now.toIso8601String();
      var newMessage = <String, dynamic>{
        'workspace_id': widget.bot.workspace!.id,
        'bot_id': widget.bot.id,
        'content': action.data.label.trim(),
        'media': [],
        'customer_id': widget.customerId,
        'sender_id': widget.customerId,
        'type': 'TEXT',
        'local_id': const Uuid().v4(),
        'sending_status': 'sending',
        'action_id': action.id,
        'unsent': false,
        'meta_tags': [],
        'is_cta': isLink,
      };

      if (!isLink) {
        var localMessage = <String, dynamic>{
          ...newMessage,
          'id': const Uuid().v4(),
          'created_at': isoDate,
        };
        Message internalNewMessage = Message.fromJson(localMessage);
        Provider.of<AppProvider>(context, listen: false)
            .addMessage(internalNewMessage);
        Timer(
            const Duration(milliseconds: 250),
            () => Provider.of<AppProvider>(context, listen: false)
                .updateMessage(Message.fromJson(
                    {...localMessage, 'sending_status': 'sent'})));
        Timer(
            const Duration(milliseconds: 500),
            () => Provider.of<AppProvider>(context, listen: false)
                .updateMessage(Message.fromJson(
                    {...localMessage, 'sending_status': 'seen'})));
        Timer(const Duration(milliseconds: 500),
            () => socket.emit('message.bot.create', newMessage));
      } else {
        socket.emit('message.bot.create', newMessage);
      }
    }
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
    var formatter = DateFormat(isToday(createdAt) ? "HH:mm" : "dd/MM/yy HH:mm");
    MessageReactions? reactions =
        widget.message.reactions ?? MessageReactions.fromJson({});

    if (widget.message.unsent == true) {
      return Consumer<AppProvider>(builder: (context, value, child) {
        Bot bot = widget.bot;
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: 32,
                height: 32,
                child: !isMine
                    ? bot.avatar == null || bot.avatar == ""
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
                                bot.name[0].toUpperCase(),
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
                              "${bot.avatar}",
                              width: 32,
                              height: 32,
                              fit: BoxFit.cover,
                            ),
                          )
                    : null,
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xffC4C9D2), width: 1),
                ),
                child: Text(
                  widget.language == LanguageOptions.en
                      ? 'Unsent message'
                      : 'Tin nhắn đã bị thu hồi',
                  style: const TextStyle(color: Color(0xffA3A9B3)),
                ),
              )
            ],
          ),
        );
      });
    }

    if (widget.message.type == 'FEEDBACK' && widget.message.content!.isEmpty) {
      return Container();
    }

    if (widget.message.type == 'ICON') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Image.asset(
            AssetImage('images/${widget.message.rating}.png').assetName,
            width: 30,
            height: 30,
            package: 'cxgenie',
          ),
          // Container(
          //   padding: const EdgeInsets.symmetric(vertical: 8),
          //   child: widget.message.content == 'HEART'
          //       ? Row(
          //           crossAxisAlignment: CrossAxisAlignment.end,
          //           mainAxisAlignment: MainAxisAlignment.end,
          //           children: [1, 2, 3, 4, 5].map((index) {
          //             return Image.asset(
          //               index <= (widget.message.rating ?? 0)
          //                   ? 'images/heart.png'
          //                   : 'images/heart_empty.png',
          //               width: 30,
          //               height: 30,
          //               package: 'cxgenie',
          //             );
          //           }).toList(),
          //         )
          //       : Image.asset(
          //           AssetImage('images/${widget.message.rating}.png').assetName,
          //           width: 30,
          //           height: 30,
          //           package: 'cxgenie',
          //         ),
          // ),
          Text(
            isToday(createdAt)
                ? "Hôm nay, ${formatter.format(createdAt)}"
                : formatter.format(createdAt),
            style: const TextStyle(fontSize: 11, color: Color(0xffA3A9B3)),
          )
        ],
      );
    }

    if (widget.message.block != null) {
      return Portal(
        child: Consumer<AppProvider>(builder: (context, value, child) {
          bool showReactions =
              value.selectedTicketMessageId == widget.message.id;
          Bot bot = widget.bot;
          var customer = value.customer;

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: 32,
                  height: 32,
                  child: !isMine
                      ? bot.avatar == null || bot.avatar == ""
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
                                  bot.name[0].toUpperCase(),
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
                                "${bot.avatar}",
                                width: 32,
                                height: 32,
                                fit: BoxFit.cover,
                              ),
                            )
                      : null,
                ),
                const SizedBox(width: 8),
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
                                      Provider.of<AppProvider>(context,
                                              listen: false)
                                          .updateSelectedTicketMessage(null);
                                    },
                                    onLongPress: () {
                                      if (!isMine) {
                                        Provider.of<AppProvider>(context,
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
                                            begin: 0,
                                            end: showReactions ? 1 : 0),
                                        builder: (context, progress, child) {
                                          return Transform(
                                            transform:
                                                Matrix4.translationValues(
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 4,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  ReactionButton(
                                                    reaction:
                                                        reactions.like != null
                                                            ? likedIcon
                                                            : likeIcon,
                                                    reacted:
                                                        reactions.like != null,
                                                    reactMessage: () =>
                                                        reactMessage('like'),
                                                    bgColor:
                                                        reactions.like != null
                                                            ? const Color(
                                                                0xff3BA55C)
                                                            : Colors.white,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  ReactionButton(
                                                    reaction:
                                                        reactions.dislike !=
                                                                null
                                                            ? dislikedIcon
                                                            : dislikeIcon,
                                                    reacted:
                                                        reactions.dislike !=
                                                            null,
                                                    reactMessage: () =>
                                                        reactMessage('dislike'),
                                                    bgColor:
                                                        reactions.dislike !=
                                                                null
                                                            ? const Color(
                                                                0xffFC8B23)
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
                                              150,
                                        ),
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: isMine
                                              ? Color(int.parse(color))
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (widget.message.quotedFrom !=
                                                null)
                                              MessageQuote(
                                                message:
                                                    widget.message.quotedFrom,
                                                isMine: isMine,
                                                customerId: widget.customerId,
                                                language: widget.language,
                                              ),
                                            MessageContentRenderer(
                                              content: widget.message.content
                                                  ?.trim(),
                                              themeColor: widget.themeColor,
                                              isMine: isMine,
                                            ),
                                            if (widget.message.block!.type ==
                                                    'NORMAL' &&
                                                widget.message.block!.actions
                                                    .isNotEmpty)
                                              MessageActions(
                                                actions: widget
                                                    .message.block!.actions,
                                                color: color,
                                                onActionPress: sendMessage,
                                                variables:
                                                    widget.message.variables,
                                              ),
                                            if (widget.isLastMessage &&
                                                widget.message.block!.type ==
                                                    'FEEDBACK')
                                              MessageFeedback(
                                                color: color,
                                                customerId: widget.customerId,
                                                botId: widget.bot.id,
                                                blockId:
                                                    widget.message.block!.id,
                                                themeColor: color,
                                                accessToken:
                                                    customer?.accessToken,
                                              ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                left: 8,
                                                right: 8,
                                                bottom: 4,
                                              ),
                                              child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      isToday(createdAt)
                                                          ? "Hôm nay, ${formatter.format(createdAt)}"
                                                          : formatter.format(
                                                              createdAt),
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        color: isMine
                                                            ? Colors.white
                                                                .withOpacity(
                                                                    0.7)
                                                            : const Color(
                                                                0xffA3A9B3),
                                                      ),
                                                    ),
                                                    if (widget.message
                                                            .sendingStatus !=
                                                        null)
                                                      Row(
                                                        children: [
                                                          const SizedBox(
                                                              width: 4),
                                                          SvgPicture.string(
                                                            widget.message
                                                                        .sendingStatus ==
                                                                    'sending'
                                                                ? sendingIcon
                                                                : widget.message
                                                                            .sendingStatus ==
                                                                        'sent'
                                                                    ? sentIcon
                                                                    : seenIcon,
                                                            width: 12,
                                                            height: 12,
                                                          )
                                                        ],
                                                      )
                                                  ]),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (!showReactions && !isMine)
                                    Positioned(
                                      right: isMine ? null : -10,
                                      bottom: 0,
                                      left: isMine ? -10 : null,
                                      child: GestureDetector(
                                        onTap: () {
                                          if (!isMine) {
                                            Provider.of<AppProvider>(context,
                                                    listen: false)
                                                .updateSelectedTicketMessage(
                                                    widget.message.id);
                                            // _showReactionModal(
                                            //     context, isMine, color, createdAt);
                                          }
                                        },
                                        child: Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            color: reactions.like == null &&
                                                    reactions.dislike == null
                                                ? Colors.white
                                                : reactions.like != null
                                                    ? const Color(0xff3BA55C)
                                                    : const Color(0xffFC8B23),
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                spreadRadius: 2,
                                                blurRadius: 7,
                                                offset: const Offset(0,
                                                    3), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: Container(
                                              child: reactions.like == null &&
                                                      reactions.dislike == null
                                                  ? SvgPicture.string(
                                                      likeIcon,
                                                      width: 12,
                                                      height: 12,
                                                    )
                                                  : reactions.like != null
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
                                    ),
                                ],
                              ),
                      ),
                      Container(
                        decoration: const BoxDecoration(),
                        child: MessageMediaView(
                          media: widget.message.media,
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(),
                        child: MessageLinkPreview(
                          metaTags: widget.message.metaTags,
                        ),
                      ),
                      if (widget.message.content?.trim() == '')
                        Column(
                          children: [
                            const SizedBox(
                              height: 4,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  isToday(createdAt)
                                      ? "Hôm nay, ${formatter.format(createdAt)}"
                                      : formatter.format(createdAt),
                                  style: const TextStyle(
                                      fontSize: 11, color: Color(0xffA3A9B3)),
                                ),
                                if (widget.message.sendingStatus != null)
                                  Row(
                                    children: [
                                      const SizedBox(width: 4),
                                      SvgPicture.string(
                                        widget.message.sendingStatus ==
                                                'sending'
                                            ? sendingGreyIcon
                                            : widget.message.sendingStatus ==
                                                    'sent'
                                                ? sentGreyIcon
                                                : seenGreyIcon,
                                        width: 12,
                                        height: 12,
                                      )
                                    ],
                                  )
                              ],
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

    return Portal(
      child: Consumer<AppProvider>(builder: (context, value, child) {
        bool showReactions = value.selectedTicketMessageId == widget.message.id;
        Bot bot = widget.bot;

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: 32,
                height: 32,
                child: !isMine
                    ? bot.avatar == null || bot.avatar == ""
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
                                bot.name[0].toUpperCase(),
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
                              "${bot.avatar}",
                              width: 32,
                              height: 32,
                              fit: BoxFit.cover,
                            ),
                          )
                    : null,
              ),
              const SizedBox(width: 8),
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
                                    Provider.of<AppProvider>(context,
                                            listen: false)
                                        .updateSelectedTicketMessage(null);
                                  },
                                  onLongPress: () {
                                    if (!isMine) {
                                      Provider.of<AppProvider>(context,
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
                                                      reactions.like != null
                                                          ? likedIcon
                                                          : likeIcon,
                                                  reacted:
                                                      reactions.like != null,
                                                  reactMessage: () =>
                                                      reactMessage('like'),
                                                  bgColor: reactions.like !=
                                                          null
                                                      ? const Color(0xff3BA55C)
                                                      : Colors.white,
                                                ),
                                                const SizedBox(width: 8),
                                                ReactionButton(
                                                  reaction:
                                                      reactions.dislike != null
                                                          ? dislikedIcon
                                                          : dislikeIcon,
                                                  reacted:
                                                      reactions.dislike != null,
                                                  reactMessage: () =>
                                                      reactMessage('dislike'),
                                                  bgColor: reactions.dislike !=
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
                                            150,
                                      ),
                                      padding: const EdgeInsets.all(4),
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
                                          if (widget.message.quotedFrom != null)
                                            MessageQuote(
                                              message:
                                                  widget.message.quotedFrom,
                                              isMine: isMine,
                                              customerId: widget.customerId,
                                              language: widget.language,
                                            ),
                                          MessageContentRenderer(
                                            content:
                                                widget.message.content?.trim(),
                                            themeColor: widget.themeColor,
                                            isMine: isMine,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                              left: 8,
                                              right: 8,
                                              bottom: 4,
                                            ),
                                            child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    isToday(createdAt)
                                                        ? "Hôm nay, ${formatter.format(createdAt)}"
                                                        : formatter
                                                            .format(createdAt),
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: isMine
                                                          ? Colors.white
                                                              .withOpacity(0.7)
                                                          : const Color(
                                                              0xffA3A9B3),
                                                    ),
                                                  ),
                                                  if (widget.message
                                                          .sendingStatus !=
                                                      null)
                                                    Row(
                                                      children: [
                                                        const SizedBox(
                                                            width: 4),
                                                        SvgPicture.string(
                                                          widget.message
                                                                      .sendingStatus ==
                                                                  'sending'
                                                              ? sendingIcon
                                                              : widget.message
                                                                          .sendingStatus ==
                                                                      'sent'
                                                                  ? sentIcon
                                                                  : seenIcon,
                                                          width: 12,
                                                          height: 12,
                                                        )
                                                      ],
                                                    )
                                                ]),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                if (!showReactions && !isMine)
                                  Positioned(
                                    right: isMine ? null : -10,
                                    bottom: 0,
                                    left: isMine ? -10 : null,
                                    child: GestureDetector(
                                      onTap: () {
                                        if (!isMine) {
                                          Provider.of<AppProvider>(context,
                                                  listen: false)
                                              .updateSelectedTicketMessage(
                                                  widget.message.id);
                                          // _showReactionModal(
                                          //     context, isMine, color, createdAt);
                                        }
                                      },
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: reactions.like == null &&
                                                  reactions.dislike == null
                                              ? Colors.white
                                              : reactions.like != null
                                                  ? const Color(0xff3BA55C)
                                                  : const Color(0xffFC8B23),
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              spreadRadius: 2,
                                              blurRadius: 7,
                                              offset: const Offset(0,
                                                  3), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Container(
                                            child: reactions.like == null &&
                                                    reactions.dislike == null
                                                ? SvgPicture.string(
                                                    likeIcon,
                                                    width: 12,
                                                    height: 12,
                                                  )
                                                : reactions.like != null
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
                                  ),
                              ],
                            ),
                    ),
                    Container(
                      decoration: const BoxDecoration(),
                      child: MessageMediaView(
                        media: widget.message.media,
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(),
                      child: MessageLinkPreview(
                        metaTags: widget.message.metaTags,
                      ),
                    ),
                    if (widget.message.content?.trim() == '')
                      Column(
                        children: [
                          const SizedBox(
                            height: 4,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                isToday(createdAt)
                                    ? "Hôm nay, ${formatter.format(createdAt)}"
                                    : formatter.format(createdAt),
                                style: const TextStyle(
                                    fontSize: 11, color: Color(0xffA3A9B3)),
                              ),
                              if (widget.message.sendingStatus != null)
                                Row(
                                  children: [
                                    const SizedBox(width: 4),
                                    SvgPicture.string(
                                      widget.message.sendingStatus == 'sending'
                                          ? sendingGreyIcon
                                          : widget.message.sendingStatus ==
                                                  'sent'
                                              ? sentGreyIcon
                                              : seenGreyIcon,
                                      width: 12,
                                      height: 12,
                                    )
                                  ],
                                )
                            ],
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
