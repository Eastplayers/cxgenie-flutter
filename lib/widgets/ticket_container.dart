import 'package:cxgenie/enums/language.dart';
import 'package:cxgenie/providers/ticket_provider.dart';
import 'package:cxgenie/widgets/ticket_tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TicketContainer extends StatefulWidget {
  const TicketContainer(
      {Key? key,
      required this.workspaceId,
      this.customerId,
      this.userToken,
      this.language = LanguageOptions.en,
      this.themeColor = '#364DE7'})
      : super(key: key);

  final String workspaceId;
  final String? customerId;
  final String? userToken;
  final String? themeColor;
  final LanguageOptions? language;

  @override
  _TicketContainerState createState() => _TicketContainerState();
}

class _TicketContainerState extends State<TicketContainer> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TicketProvider(),
      child: TicketTab(
        workspaceId: widget.workspaceId,
        customerId: widget.customerId,
        userToken: widget.userToken,
        themeColor: "${widget.themeColor}",
        language: widget.language,
      ),
    );
  }
}
