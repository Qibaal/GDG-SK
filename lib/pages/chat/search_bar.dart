// lib/pages/chat/search_bar.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gemexplora/providers/auth_provider.dart';
import 'package:gemexplora/services/api_service.dart';
import 'package:gemexplora/widgets/loading_screen.dart';
import 'package:gemexplora/pages/result/search_result.dart';

class SearchBar extends StatefulWidget {
  final String origin;
  const SearchBar({Key? key, required this.origin}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final _ctrl = TextEditingController();
  late final ApiService _api;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _api = ApiService();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _ctrl,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: 'Search destinations, experiences...',
              prefixIcon: const Icon(Icons.search, color: Color(0xFF858C95)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        _isLoading
            ? const SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  foregroundColor: const Color(0xFF48CAE4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  minimumSize: const Size(0, 48),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.auto_awesome, size: 16, color: Colors.black),
                    SizedBox(width: 4),
                    Text(
                      'Discover',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }

  Future<void> _submit() async {
    final query = _ctrl.text.trim();
    if (query.isEmpty) return;

    final token = context.read<AuthProvider>().token!;

    // Show overlay loading
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (_) => const LoadingScreen(),
    );

    try {
      final resultData = await _api.getUserSearchResult(query, token, widget.origin);
      if (!mounted) return;
      Navigator.pop(context); // remove loading screen

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SearchResultPage(resultData: resultData),
        ),
      );
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // remove loading screen
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }
}
