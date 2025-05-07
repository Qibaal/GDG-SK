import 'package:flutter/material.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;

  ChatMessage({required this.text, required this.isUser, required this.time});
}

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  const MessageBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:6, horizontal:8),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser) const CircleAvatar(
            backgroundColor: Color(0xFF6750A4), radius:16, child: Icon(Icons.smart_toy_outlined, size:16, color:Colors.white),
          ),
          if (!message.isUser) const SizedBox(width:8),
          Flexible(
            child: Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
              padding: const EdgeInsets.symmetric(horizontal:16, vertical:10),
              decoration: BoxDecoration(
                color: message.isUser ? Theme.of(context).colorScheme.primary : isLight ? Colors.white : Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(20).copyWith(
                  bottomRight: message.isUser ? Radius.zero : null,
                  bottomLeft: !message.isUser ? Radius.zero : null,
                ),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius:2, offset: const Offset(0,1))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(message.text, style: TextStyle(color: message.isUser ? Colors.white : Theme.of(context).textTheme.bodyLarge!.color, fontSize:16)),
                  const SizedBox(height:4),
                  Text(
                    '${message.time.hour.toString().padLeft(2,'0')}:${message.time.minute.toString().padLeft(2,'0')}',
                    style: TextStyle(color: message.isUser ? Colors.white70 : Theme.of(context).textTheme.bodySmall!.color, fontSize:12),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ),
          if (message.isUser) const SizedBox(width:8),
          if (message.isUser) const CircleAvatar(backgroundColor: Colors.deepPurple, radius:16, child: Icon(Icons.person, size:16, color:Colors.white)),
        ],
      ),
    );
  }
}