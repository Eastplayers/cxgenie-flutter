import 'package:cxgenie/cxgenie.dart';
import 'package:flutter/material.dart';

class ScreenArguments {
  final String userId;
  final String workspaceId;
  final String? themeColor;

  ScreenArguments(this.userId, this.workspaceId, this.themeColor);
}

class Ticket extends StatelessWidget {
  const Ticket({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TicketList(),
    );
  }
}

class TicketList extends StatelessWidget {
  const TicketList({super.key});
  static const routeName = '/ticketList';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    return Scaffold(
      body: Center(
          child: TicketContainer(
              chatUserId: args.userId,
              workspaceId: args.workspaceId,
              themeColor: args.themeColor)),
    );
  }
}
