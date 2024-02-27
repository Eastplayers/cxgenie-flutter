import 'package:cxgenie/models/message.dart';
import 'package:cxgenie/widgets/video.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MessageMediaView extends StatefulWidget {
  final List<MessageMedia>? media;

  const MessageMediaView({
    Key? key,
    this.media,
  }) : super(key: key);

  @override
  MessageMediaViewState createState() => MessageMediaViewState();
}

class MessageMediaViewState extends State<MessageMediaView> {
  @override
  Widget build(BuildContext context) {
    if (widget.media == null || widget.media!.isEmpty) {
      return Container();
    }

    if (widget.media!.length > 1 ||
        widget.media![0].type == null ||
        widget.media![0].type!.contains('image')) {
      return Column(
        children: widget.media!
            .map((mediaItem) => GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            contentPadding: const EdgeInsets.all(0),
                            insetPadding: const EdgeInsets.all(16),
                            elevation: 0,
                            shadowColor: const Color.fromRGBO(23, 24, 26, 0.5),
                            backgroundColor: Colors.transparent,
                            content: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: SizedBox(
                                width: (MediaQuery.of(context).size.width),
                                height: (MediaQuery.of(context).size.height),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
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
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                            width: 32,
                                            height: 32,
                                            decoration: BoxDecoration(
                                                color: const Color.fromRGBO(
                                                    0, 0, 0, 0.7),
                                                borderRadius:
                                                    BorderRadius.circular(16)),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
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
                            color: const Color(0xffD6DAE1), width: 1)),
                    child: Image.network(
                      mediaItem.url,
                      fit: BoxFit.cover,
                    ),
                  ),
                ))
            .toList(),
      );
    }

    return Video(url: widget.media![0].url);
  }
}
