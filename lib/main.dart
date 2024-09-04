import 'package:chatbot_ai/chatscreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatbot AI',
      debugShowCheckedModeBanner: false,
      home: Chatscreen(),
    );
  }
}
