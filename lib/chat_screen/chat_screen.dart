import 'package:flutter/material.dart';
import 'package:gemexplora/search_result_page.dart';
import 'message_bubble.dart';
import 'typing_indicator.dart';
import 'settings_bottom_sheet.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    _messageController.clear();
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true, time: DateTime.now()));
      _isTyping = true;
    });

    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() => _isTyping = false);

      if (text.toLowerCase().contains("travel to") || text.toLowerCase().contains("holiday")) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const SearchResultPage()),
        );
      } else {
        setState(() {
          _messages.add(ChatMessage(
            text: _generateResponse(text),
            isUser: false,
            time: DateTime.now(),
          ));
        });
        _scrollToBottom();
      }
    });
  }

  String _generateResponse(String text) {
    final lower = text.toLowerCase();
    if (lower.contains('hello') || lower.contains('hi')) {
      return 'Hello! How can I assist you today?';
    } else if (lower.contains('help')) {
      return 'I\'m here to help! What do you need assistance with?';
    } else if (lower.contains('thanks') || lower.contains('thank you')) {
      return 'You\'re welcome! Is there anything else you\'d like to know?';
    } else if (lower.contains('bye')) {
      return 'Goodbye! Feel free to return if you have more questions!';
    }
    return 'That\'s an interesting point. Would you like to know more about this topic?';
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chat Assistant'),
        centerTitle: true,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => showModalBottomSheet(
              context: context,
              builder: (_) => const SettingsBottomSheet(),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: isLight ? Colors.grey[100] : Colors.grey[900],
              child: _messages.isEmpty
                  ? _buildWelcome()
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(8),
                      itemCount: _messages.length,
                      itemBuilder: (_, i) => MessageBubble(message: _messages[i]),
                    ),
            ),
          ),
          if (_isTyping)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TypingIndicator(),
            ),
          _buildComposer(),
        ],
      ),
    );
  }

  Widget _buildWelcome() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF6750A4),
              child: Icon(Icons.smart_toy_outlined, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 24),
            const Text('Welcome to AI Assistant',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('Ask me anything to get started!',
                style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 32),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: ['Hello AI!', 'Tell me a joke', 'What can you do?', 'Help me with coding']
                  .map((t) => ActionChip(label: Text(t), onPressed: () => _handleSubmitted(t)))
                  .toList(),
            ),
          ],
        ),
      );

  Widget _buildComposer() => Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.05*255).toInt()),
              blurRadius: 4,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.attach_file_outlined),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('File attachment coming soon')),
                );
              },
            ),
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Message...',
                  filled: true,
                  fillColor:
                      Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha((0.5*255).toInt()),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                textCapitalization: TextCapitalization.sentences,
                maxLines: null,
                onSubmitted: _handleSubmitted,
              ),
            ),
            const SizedBox(width: 8),
            FloatingActionButton(
              mini: true,
              elevation: 2,
              onPressed: () => _handleSubmitted(_messageController.text),
              child: const Icon(Icons.send),
            ),
          ],
        ),
      );
}