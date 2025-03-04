import 'package:cxgenie/widgets/linkify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageContentRenderer extends StatefulWidget {
  final String? content;
  final String themeColor;
  final bool isMine;

  const MessageContentRenderer({
    Key? key,
    this.content,
    required this.themeColor,
    required this.isMine,
  }) : super(key: key);

  @override
  MessageContentRendererState createState() => MessageContentRendererState();
}

class MessageContentRendererState extends State<MessageContentRenderer> {
  @override
  Widget build(BuildContext context) {
    String color = widget.themeColor.replaceAll("#", "0xff");

    return RegExp('<[^>]*>', multiLine: true, caseSensitive: false)
            .hasMatch("${widget.content?.trim()}")
        ? Container(
            constraints: BoxConstraints(minWidth: 110),
            child: HtmlWidget(
              """<div class="container">${widget.content?.trim()}<div/>""",
              onTapUrl: (url) async {
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url));
                  return true;
                }
                return false;
              },
              customStylesBuilder: (element) {
                if (element.classes.contains('container')) {
                  return {
                    'color': widget.isMine ? 'white' : '#2C2E33',
                    'font-size': '14px',
                    'padding': '0px 8px',
                    'margin': '0px',
                    'width': 'auto'
                  };
                }

                if (element.localName == 'p') {
                  return {
                    'padding': '0px',
                    'margin': '2px 0px',
                    'width': 'auto',
                  };
                }

                if (element.localName == 'ol' || element.localName == 'ul') {
                  return {
                    'padding': '0px',
                    'margin': '2px 16px',
                    'width': 'auto',
                  };
                }

                if (element.localName == 'a') {
                  return {
                    'color': !widget.isMine ? widget.themeColor : 'white',
                    'font-size': '14px',
                    'margin': '0px',
                    'width': 'auto'
                  };
                }

                return null;
              },
              textStyle: TextStyle(
                fontSize: 14,
                color: widget.isMine ? Colors.white : const Color(0xff2C2E33),
                decorationColor:
                    widget.isMine ? Colors.white : Color(int.parse(color)),
              ),
            ),
          )
        : Container(
            constraints: BoxConstraints(minWidth: 110),
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Linkify(
              onOpen: (link) async {
                if (await canLaunchUrl(Uri.parse(link.url))) {
                  await launchUrl(Uri.parse(link.url));
                }
              },
              text: Bidi.stripHtmlIfNeeded("${widget.content?.trim()}").trim(),
              style: TextStyle(
                color: widget.isMine ? Colors.white : const Color(0xff2C2E33),
                fontSize: 14,
              ),
              linkStyle: TextStyle(
                color: widget.isMine
                    ? Colors.white
                    : Color(
                        int.parse(color),
                      ),
              ),
            ),
          );
  }
}
