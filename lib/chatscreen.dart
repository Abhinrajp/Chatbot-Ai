import 'dart:convert';
import 'dart:developer';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Chatscreen extends StatefulWidget {
  const Chatscreen({super.key});

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  final uri =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyBp-RjAkcPVDBGXE-aDmRG7N6jJegoqVrc";
  final header = {'Content-Type': 'application/json'};

  ChatUser currentUser = ChatUser(id: '1', firstName: 'Abhinraj');
  ChatUser chatbot = ChatUser(id: '2', firstName: 'Chat GPT');
  List<ChatMessage> allmessages = [];
  List<ChatUser> typing = [];
  getdata(ChatMessage m) async {
    typing.add(chatbot);
    allmessages.insert(0, m);
    setState(() {});

    var data = {
      "contents": [
        {
          "parts": [
            {"text": m.text}
          ]
        }
      ]
    };
    await http
        .post(Uri.parse(uri), headers: header, body: jsonEncode(data))
        .then((value) {
      if (value.statusCode == 200) {
        var result = jsonDecode(value.body);
        log(result['candidates'][0]['content']['parts'][0]['text']);
        ChatMessage msgOne = ChatMessage(
            user: chatbot,
            createdAt: DateTime.now(),
            text: result['candidates'][0]['content']['parts'][0]['text']);
        allmessages.insert(0, msgOne);
        setState(() {});
      } else {
        log('Error: ${value.statusCode}, Body: ${value.body}');
      }
    }).catchError((e) {});
    typing.remove(chatbot);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DashChat(
          messageOptions: MessageOptions(
            showTime: true,
            currentUserContainerColor: Colors.indigo[300],
            currentUserTimeTextColor: Colors.grey[300],
          ),
          typingUsers: typing,
          currentUser: currentUser,
          onSend: (ChatMessage m) {
            getdata(m);
          },
          messages: allmessages),
    );
  }
}
// AIzaSyBp-RjAkcPVDBGXE-aDmRG7N6jJegoqVrc