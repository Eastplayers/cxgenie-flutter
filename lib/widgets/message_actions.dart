import 'package:cxgenie/models/block_action.dart';
import 'package:cxgenie/widgets/icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageActions extends StatefulWidget {
  const MessageActions({
    Key? key,
    required this.actions,
    required this.color,
    required this.onActionPress,
  }) : super(key: key);

  final List<BlockAction> actions;
  final String color;
  final Function onActionPress;

  @override
  MessageActionsState createState() => MessageActionsState();
}

class MessageActionsState extends State<MessageActions> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 1,
            color: Color(0xffF2F3F5),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.actions
            .map(
              (action) => GestureDetector(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: Color(0xffF2F3F5),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          action.data.label,
                          style: TextStyle(
                              color: Color(int.parse(
                                widget.color,
                              )),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SvgPicture.string(
                        chevronRight,
                        width: 24,
                        height: 24,
                      )
                    ],
                  ),
                ),
                onTap: () async {
                  if (action.type == "LINK") {
                    if (await canLaunchUrl(Uri.parse(action.data.content!))) {
                      await launchUrl(Uri.parse("${action.data.content}"));
                    }
                  }

                  widget.onActionPress(action);
                },
              ),
            )
            .toList(),
      ),
    );
  }
}
