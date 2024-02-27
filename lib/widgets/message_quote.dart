import 'package:cxgenie/enums/language.dart';
import 'package:cxgenie/models/message.dart';
import 'package:cxgenie/widgets/video.dart';
import 'package:flutter/material.dart';

class MessageQuote extends StatefulWidget {
  final Message? message;
  final bool isMine;
  final String customerId;
  final Message? originalMessage;
  final LanguageOptions? language;

  const MessageQuote({
    Key? key,
    required this.message,
    required this.isMine,
    required this.customerId,
    this.originalMessage,
    this.language,
  }) : super(key: key);

  @override
  MessageQuoteState createState() => MessageQuoteState();
}

class MessageQuoteState extends State<MessageQuote> {
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.only(
        left: 6,
        right: 6,
        top: 6,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xff000000).withOpacity(widget.isMine ? 0.2 : 0.05),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.language == LanguageOptions.en
                            ? "Replied to"
                            : "Đã trả lời",
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color(0xff202225).withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.message?.senderId == widget.customerId
                            ? widget.language == LanguageOptions.en
                                ? "You"
                                : "Bạn"
                            : "${widget.message?.sender?.name ?? widget.message?.bot?.name}",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff202225),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.message!.content == null
                        ? widget.message!.media!.length == 1 &&
                                widget.message!.media![0].type!
                                    .contains('video')
                            ? 'video'
                            : widget.language == LanguageOptions.en
                                ? "image"
                                : "hình ảnh"
                        : "${widget.message?.content}",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xff7D828B),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (widget.message!.media != null &&
              widget.message!.media!.isNotEmpty)
            Container(
              clipBehavior: Clip.hardEdge,
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: widget.message!.media!.length == 1 &&
                      widget.message!.media![0].type != null &&
                      widget.message!.media![0].type!.contains('video')
                  ? Video(url: widget.message!.media![0].url, playable: false)
                  : Image.network(
                      "${widget.message!.media?[0].url}",
                      fit: BoxFit.cover,
                    ),
            )
        ],
      ),
    );
  }
}
