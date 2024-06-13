import 'package:cxgenie/cxgenie.dart';
import 'package:cxgenie/enums/language.dart';
import 'package:cxgenie/models/ticket.dart';
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
        elevation: 0,
      ),
      body: const SafeArea(
        child: Center(
          child: Chat(
            botId: 'ce1e564f-c6a8-4b9a-a7a0-b773ca57e6f6',
            // userToken: 'USER_TOKEN',
            language: LanguageOptions.vi,
          ),
        ),
      ),
    );
  }
}
