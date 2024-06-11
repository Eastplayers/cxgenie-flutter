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
          child: Tickets(
            botId: 'f6bee7f9-0dc8-4de6-8bd5-cce436b4fa56',
            // userToken: 'USER_TOKEN',
            language: LanguageOptions.vi,
          ),
        ),
      ),
    );
  }
}
