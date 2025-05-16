// lib/pages/chat/chat_history_preview.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gemexplora/providers/auth_provider.dart';
import 'package:gemexplora/services/api_service.dart';
import 'package:gemexplora/pages/result/search_result.dart';
import 'package:gemexplora/pages/chat/chat_history.dart';

class ChatHistoryPreview extends StatefulWidget {
  final String email;
  const ChatHistoryPreview({Key? key, required this.email}) : super(key: key);

  @override
  State<ChatHistoryPreview> createState() => _ChatHistoryPreviewState();
}

class _ChatHistoryPreviewState extends State<ChatHistoryPreview> {
  late Future<List<dynamic>> _previewFuture;

  @override
  void initState() {
    super.initState();
    final token = context.read<AuthProvider>().token!;
    _previewFuture = ApiService()
        .getUserHistory(widget.email, token, isPreview: true);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _previewFuture,
      builder: (ctx, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Text(
            'Error loading history:\n${snap.error}',
            style: const TextStyle(color: Colors.red),
          );
        }

        final history = snap.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            if (history.isEmpty) ...[
              const Text('No recent chats'),
            ] else ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: history.map((rec) {
                  final origin = rec['Origin'] as String;
                  final responseData = rec['Response'] as Map<String, dynamic>;
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SearchResultPage(
                            resultData: responseData,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      backgroundColor: const Color(0xFFADE8F4),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(origin),
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 8),
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ChatHistoryPage(email: widget.email)),
              ),
              child: const Text('See more →'),
            ),
          ],
        );
      },
    );
  }
}
