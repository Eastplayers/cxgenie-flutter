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
            botId: '8388af8d-4f3e-41d3-9a91-1f3c251a8d6c',
            // userToken: 'USER_TOKEN',
            language: LanguageOptions.vi,
          ),
        ),
      ),
    );
  }
}
