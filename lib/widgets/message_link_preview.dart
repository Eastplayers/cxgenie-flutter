import 'package:cxgenie/models/message.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageLinkPreview extends StatefulWidget {
  final List<MessageMetaTag>? metaTags;

  const MessageLinkPreview({
    Key? key,
    this.metaTags,
  }) : super(key: key);

  @override
  MessageLinkPreviewState createState() => MessageLinkPreviewState();
}

class MessageLinkPreviewState extends State<MessageLinkPreview> {
  @override
  Widget build(BuildContext context) {
    if (widget.metaTags == null || widget.metaTags!.isEmpty) {
      return Container();
    }

    return Column(
      children: widget.metaTags!
          .map((metaTag) => GestureDetector(
                onTap: () async {
                  if (await canLaunchUrl(Uri.parse(metaTag.url))) {
                    await launchUrl(Uri.parse(metaTag.url));
                  }
                },
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  margin: const EdgeInsets.only(top: 4),
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (metaTag.image != null && metaTag.image!.isNotEmpty)
                        Image.network(
                          "${metaTag.image!.startsWith('//') ? metaTag.image!.replaceFirst(RegExp(r'//'), 'https://') : metaTag.image}",
                          fit: BoxFit.cover,
                          width: 200,
                          height: 113,
                        ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              metaTag.title.trim(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                height: 1.2,
                                color: Color(0xff202225),
                              ),
                            ),
                            if (metaTag.description != null)
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                child: Text(
                                  metaTag.description!.trim(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xff7d828b),
                                    height: 1.2,
                                  ),
                                ),
                              )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }
}
