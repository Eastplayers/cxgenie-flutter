import 'package:cxgenie/cxgenie.dart';
import 'package:cxgenie/enums/language.dart';
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
          elevation: 0),
      body: const Center(
          child: CXGenie(
        botId: '5b342fb6-0fff-4baf-a74d-d65433dd6946',
        userToken: '0ec9f333eabacc46c3b049864272781c614dc87c',
        language: LanguageOptions.vi,
      )),
    );
  }
}
