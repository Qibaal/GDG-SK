import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gemexplora/providers/auth_provider.dart';
import 'package:gemexplora/services/api_service.dart';
import 'package:gemexplora/pages/result/search_result.dart';

class ChatHistoryPage extends StatelessWidget {
  final String email;
  
  const ChatHistoryPage({ Key? key, required this.email }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final token = context.read<AuthProvider>().token!;
    print('📧 Email in ChatHistoryPage: $email');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: ApiService().getUserHistory(email, token),
        builder: (ctx, snap) {
          if (snap.connectionState != ConnectionState.done){
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError){
            return Center(child: Text('Failed to load history'));
          }

          final history = snap.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: history.length,
            itemBuilder: (ctx, i) {
              final rec = history[i];
              final origin = rec['Origin'] as String;
              final prompt = rec['Prompt'] as String;
              final response = rec['Response'] as Map<String, dynamic>;

              return ExpansionTile(
                title: Text(origin, style: const TextStyle(fontWeight: FontWeight.bold)),
                children: [
                  ListTile(
                    title: Text(prompt),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SearchResultPage(
                            resultData: response,
                          ),
                        ),
                      );
                    },
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}
