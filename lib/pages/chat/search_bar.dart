// lib/pages/chat/search_bar.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gemexplora/providers/auth_provider.dart';
import 'package:gemexplora/services/api_service.dart';
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
    return Stack(
      children: [
        TextField(
          controller: _ctrl,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: 'Search destinations, experiences...',
            prefixIcon: const Icon(Icons.search, color: Color(0xFF858C95)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onSubmitted: (_) => _submit(),
        ),
        if (_isLoading)
          Positioned.fill(
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16),
              child: const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
        Positioned(
          right: 4,
          top: 4,
          bottom: 4,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF59E0B),
              foregroundColor: const Color(0xFF48CAE4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: const [
              Icon(Icons.auto_awesome, size: 16, color: Colors.black),
              SizedBox(width: 4),
              Text(
                'Discover',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    final query = _ctrl.text.trim();
    if (query.isEmpty) return;

    final token = context.read<AuthProvider>().token!;
    setState(() => _isLoading = true);

    try {
      final resultData = await _api.postSearchHandler(query, token, widget.origin);
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SearchResultPage(resultData: resultData),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }
}
