import 'package:flutter/material.dart';

class Tickets extends StatefulWidget {
  const Tickets(
      {Key? key, required this.workspaceId, this.chatUserId, this.userToken})
      : super(key: key);

  final String workspaceId;
  final String? chatUserId;
  final String? userToken;

  @override
  _TicketsState createState() => _TicketsState();
}

class _TicketsState extends State<Tickets> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width),
      height: (MediaQuery.of(context).size.height),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Container(
            child: const Row(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(hintText: "Type message"),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
