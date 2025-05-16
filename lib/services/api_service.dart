import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final String baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:8081';
  
  Future<Map<String, dynamic>> getUserSearchResult(String prompt, String token, String origin) async {
    final url = Uri.parse('$baseUrl/search-handler');
    final resp = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'origin': origin, 
        'prompt': prompt
      }),
    );
    
    if (resp.statusCode == 200) return jsonDecode(resp.body);
    throw Exception('Search-handler failed (${resp.statusCode})');
  }

  Future<Map<String, dynamic>> getUserTripPlan(String prompt, String token, String origin, Uri url) async {
    final resp = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'origin': origin, 
        'prompt': prompt
      }),
    );
    
    if (resp.statusCode == 200) return jsonDecode(resp.body);
    throw Exception('Search-handler failed (${resp.statusCode})');
  }
  
  Future<List<dynamic>> getUserHistory(
    String email,
    String token, {
    bool isPreview = false,
  }) async {
    final url = Uri.parse('$baseUrl/prompts');
    final resp = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'email': email}),
    );
    if (resp.statusCode == 200) {
      final List<dynamic> history = jsonDecode(resp.body) as List<dynamic>;
      history.sort((a, b) {
        final dtA = DateTime.parse(a['CreatedAt'] as String);
        final dtB = DateTime.parse(b['CreatedAt'] as String);
        return dtB.compareTo(dtA);
      });
      return isPreview ? history.take(5).toList() : history;
    }
    throw Exception('History fetch failed (${resp.statusCode})');
  }
}