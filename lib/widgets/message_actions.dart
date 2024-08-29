import 'package:cxgenie/models/block_action.dart';
import 'package:cxgenie/widgets/icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageActions extends StatefulWidget {
  const MessageActions({
    super.key,
    required this.actions,
    required this.color,
    required this.onActionPress,
    this.variables,
  });

  final List<BlockAction> actions;
  final String color;
  final Function onActionPress;
  final Map<String, String?>? variables;

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
        children: widget.actions.map((action) {
          var actionLabel = getValueFromVariable(action.data.label);
          return GestureDetector(
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
                      actionLabel ?? '',
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
                var content = getValueFromVariable(action.data.content ?? '');
                if (content != null) {
                  var parsedUri = Uri.parse(Uri.encodeFull(content));
                  // if (await canLaunchUrl(parsedUri)) {
                  await launchUrl(parsedUri);
                  // } else {
                  //   print('Could not launch $parsedUri');
                  // }
                }
              }
              widget.onActionPress(action);
            },
          );
        }).toList(),
      ),
    );
  }

  String? getValueFromVariable(String key) {
    if (key.startsWith('{{')) {
      var extractedKey = key.substring(2, key.length - 2);
      return widget.variables![extractedKey] as String?;
    }

    return key;
  }
}
