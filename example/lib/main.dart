import 'package:cxgenie/cxgenie.dart';
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
    return const Scaffold(
      body: Center(
          child: ChatContainer(
        virtualAgentId: "54d9ac51-26f1-4728-b316-1bd966c63a96",
        userToken: '0ec9f333eabacc46c3b049864272781c614dc87c',
      )),
    );
  }
}
