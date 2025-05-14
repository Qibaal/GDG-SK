import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'search_result.dart';
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:gemexplora/providers/auth_provider.dart';

var logger = Logger();
class ChatHistoryPage extends StatelessWidget {
  const ChatHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final history = {
      'Bali, Indonesia': [
        'Find beaches in Bali',
        'Budget under 50K',
        'Top 5 attractions',
      ],
      'Tokyo, Japan': [
        'Ramen places',
        'Anime culture tour',
      ]
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: history.entries.map((entry) {
          return ExpansionTile(
            title: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold)),
            children: entry.value.map((query) {
              return ListTile(
                title: Text(query), 
                onTap: () async {
                  try {
                    final response = await http.get(
                      Uri.parse('http://localhost:8080/query-response?query=$query'),
                      headers: {
                        'Authorization': 'Bearer ${Provider.of<AuthProvider>(context, listen: false).token}',
                      },
                    );

                    if (response.statusCode == 200) {
                      final result = jsonDecode(response.body);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SearchResultPage(
                            travelQuery: query,
                            resultData: result,
                          ),
                        ),
                      );
                    } else {
                      logger.e('API failed: ${response.statusCode} - ${response.body}');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to load results')),
                      );
                    }
                  } catch (e) {
                    logger.e('Fetch error: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('An error occurred')),
                    );
                  }
                },
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}
