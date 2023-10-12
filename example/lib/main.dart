import 'package:cxgenie/cxgenie.dart';
import 'package:cxgenie/enums/language.dart';
import 'package:example/ticket.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
      routes: {TicketList.routeName: (context) => const TicketList()},
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Chat'),
          backgroundColor: const Color(0xFF364de7),
          elevation: 0),
      body: Center(
          child: ChatContainer(
        virtualAgentId: "-",
        userToken: '-',
        showChatWithAgent: true,
        language: LanguageOptions.vi,
        onChatWithAgentClick:
            (String userId, String workspaceId, String themeColor) {
          Navigator.pushNamed(context, TicketList.routeName,
              arguments: ScreenArguments(userId, workspaceId, themeColor));
        },
      )),
    );
  }
}
