// lib/pages/chat/chat_header.dart

import 'package:flutter/material.dart';

class ChatHeader extends StatelessWidget {
  const ChatHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
      SizedBox(height: kToolbarHeight),
      Text(
        'Welcome back, Traveler',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      SizedBox(height: 4),
      Text(
        'Where would you like to explore today?',
        style: TextStyle(fontSize: 14, color: Color(0xFF858C95)),
      ),
    ]);
  }
}
