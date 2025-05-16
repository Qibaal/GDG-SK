// // lib/services/history_service.dart

// // import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// class HistoryService {
//   final String baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:8081';

//   // Future<void> saveQuery(String query, String userId, String token) async {
//   Future<void> saveQuery(String query,String token) async {
//     final url = Uri.parse('$baseUrl/save-query');
//     final resp = await http.post(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//       body: jsonEncode({'userId': userId, 'query': query}),
//     );
//     if (resp.statusCode != 200) {
//       throw Exception('Failed to save query history');
//     }
//   }
// }
