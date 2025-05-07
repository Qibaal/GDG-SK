import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Chat Interface',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.light,
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

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
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        time: DateTime.now(),
      ));
      _isTyping = true;
    });
    
    _scrollToBottom();

    // Simulate AI response after a delay
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage(
          text: _generateResponse(text),
          isUser: false,
          time: DateTime.now(),
        ));
      });
      _scrollToBottom();
    });
  }

  String _generateResponse(String text) {
    // Simple response generation, replace with actual AI response logic
    if (text.toLowerCase().contains('hello') || text.toLowerCase().contains('hi')) {
      return 'Hello! How can I assist you today?';
    } else if (text.toLowerCase().contains('help')) {
      return 'I\'m here to help! What do you need assistance with?';
    } else if (text.toLowerCase().contains('thanks') || text.toLowerCase().contains('thank you')) {
      return 'You\'re welcome! Is there anything else you\'d like to know?';
    } else if (text.toLowerCase().contains('bye')) {
      return 'Goodbye! Feel free to return if you have more questions!';
    } else {
      return 'That\'s an interesting point. Would you like to know more about this topic?';
    }
  }

  void _scrollToBottom() {
    // Use Future.delayed to ensure the scroll happens after the UI updates
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
    final brightness = Theme.of(context).brightness;
    final isLightMode = brightness == Brightness.light;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chat Assistant'),
        centerTitle: true,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => SettingsBottomSheet(),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isLightMode ? Colors.grey[100] : Colors.grey[900],
              ),
              child: _messages.isEmpty
                  ? _buildWelcomeScreen()
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(8.0),
                      itemCount: _messages.length,
                      itemBuilder: (_, index) {
                        return MessageBubble(message: _messages[index]);
                      },
                    ),
            ),
          ),
          if (_isTyping)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              alignment: Alignment.centerLeft,
              child: TypingIndicator(),
            ),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Color(0xFF6750A4),
            child: Icon(
              Icons.smart_toy_outlined,
              size: 60,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Welcome to AI Assistant',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Ask me anything to get started!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                _suggestionChip('Hello AI!'),
                _suggestionChip('Tell me a joke'),
                _suggestionChip('What can you do?'),
                _suggestionChip('Help me with coding'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _suggestionChip(String text) {
    return ActionChip(
      label: Text(text),
      onPressed: () {
        _handleSubmitted(text);
      },
    );
  }

  Widget _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              // Implement file attachment
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              ),
              textCapitalization: TextCapitalization.sentences,
              maxLines: null,
              onSubmitted: _handleSubmitted,
            ),
          ),
          const SizedBox(width: 8.0),
          FloatingActionButton(
            onPressed: () => _handleSubmitted(_messageController.text),
            elevation: 2,
            mini: true,
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
  });
}

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isUser)
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              radius: 16,
              child: const Icon(
                Icons.smart_toy_outlined,
                size: 16,
                color: Colors.white,
              ),
            ),
          if (!message.isUser) const SizedBox(width: 8.0),
          
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: message.isUser
                    ? Theme.of(context).colorScheme.primary
                    : isLightMode
                        ? Colors.white
                        : Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(20.0).copyWith(
                  bottomRight: message.isUser ? Radius.zero : null,
                  bottomLeft: !message.isUser ? Radius.zero : null,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: message.isUser
                          ? Colors.white
                          : Theme.of(context).textTheme.bodyLarge?.color,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    _formatTime(message.time),
                    style: TextStyle(
                      color: message.isUser
                          ? Colors.white.withOpacity(0.7)
                          : Theme.of(context).textTheme.bodySmall?.color,
                      fontSize: 12.0,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ),
          
          if (message.isUser) const SizedBox(width: 8.0),
          if (message.isUser)
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              radius: 16,
              child: const Icon(
                Icons.person,
                size: 16,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({Key? key}) : super(key: key);

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              radius: 16,
              child: const Icon(
                Icons.smart_toy_outlined,
                size: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.white
                    : Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: List.generate(
                  3,
                  (index) => _buildDot(index * 0.3),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDot(double delay) {
    final delayedAnimation = DelayTween(
      begin: 0.0,
      end: 1.0,
      delay: delay,
    ).animate(_controller);

    return AnimatedBuilder(
      animation: delayedAnimation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2.0),
          height: 8.0 * (0.5 + delayedAnimation.value * 0.5),
          width: 8.0 * (0.5 + delayedAnimation.value * 0.5),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5 + delayedAnimation.value * 0.5),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}

class DelayTween extends Tween<double> {
  final double delay;

  DelayTween({
    required this.delay,
    required double begin,
    required double end,
  }) : super(begin: begin, end: end);

  @override
  double lerp(double t) {
    return super.lerp((t - delay).clamp(0.0, 1.0));
  }
}

class SettingsBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.settings),
              const SizedBox(width: 16.0),
              const Text(
                'Settings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.color_lens_outlined),
            title: const Text('Appearance'),
            subtitle: const Text('Light & Dark mode'),
            onTap: () {
              // Implement theme switching
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Theme settings coming soon')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('Clear History'),
            onTap: () {
              Navigator.pop(context);
              // Implement clear chat history
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Chat history cleared')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context);
              showAboutDialog(
                context: context,
                applicationName: 'AI Chat Assistant',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.smart_toy_outlined),
                children: [
                  const Text('A beautiful Flutter AI Chat interface'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}