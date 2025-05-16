// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// /// Authentication service that handles user authentication operations
// class AuthService {
//   // Secure storage for tokens and user data
//   final _secureStorage = const FlutterSecureStorage();
  
//   // Google Sign-In instance
//   late final GoogleSignIn _googleSignIn;
  
//   // Singleton instance
//   static final AuthService _instance = AuthService._internal();
  
//   // Factory constructor to return the singleton instance
//   factory AuthService() => _instance;
  
//   // Private constructor for singleton pattern
//   AuthService._internal() {
//     _initGoogleSignIn();
//   }
  
//   // Initialize Google Sign-In with platform-specific settings
//   void _initGoogleSignIn() {
//     if (kIsWeb) {
//       // Web requires clientId
//       _googleSignIn = GoogleSignIn(
//         clientId: '112571618899-53i2orp47rs7m50rr160g27aeu5tjg7b.apps.googleusercontent.com',
//         scopes: ['email', 'profile'],
//       );
//     } else {
//       // Mobile platforms (Android/iOS) get client ID from Google services config files
//       _googleSignIn = GoogleSignIn(
//         scopes: ['email', 'profile'],
//       );
//     }
//   }

//   /// Reads the base URL from .env (falls back to localhost)
//   String get _baseUrl => dotenv.env['API_BASE_URL'] ?? 'http://localhost:8081';
  
//   /// Helper to build Uri for an endpoint
//   Uri _uri(String path) => Uri.parse('$_baseUrl$path');

//   /// Sign in with email and password
//   Future<bool> signInWithEmailAndPassword(String email, String password) async {
//     try {
//       final url = _uri('/login');
      
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'email': email, 'password': password}),
//       );
      
//       if (response.statusCode >= 200 && response.statusCode < 300) {
//         final data = jsonDecode(response.body);
        
//         // Store the authentication token
//         await _secureStorage.write(key: 'auth_token', value: data['token'] ?? '');
        
//         // Store user info if available
//         if (data['user'] != null) {
//           await _secureStorage.write(key: 'user_data', value: jsonEncode(data['user']));
//         }
        
//         return true;
//       }
      
//       return false;
//     } catch (e) {
//       debugPrint('Error during email/password sign in: $e');
//       return false;
//     }
//   }
  
//   /// Register a new user with email and password
//   Future<bool> registerUser(String email, String password) async {
//     try {
//       final url = _uri('/register');
      
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'email': email, 'password': password}),
//       );
      
//       if (response.statusCode >= 200 && response.statusCode < 300) {
//         final data = jsonDecode(response.body);
        
//         // Store the authentication token
//         await _secureStorage.write(key: 'auth_token', value: data['token'] ?? '');
        
//         // Store user info if available
//         if (data['user'] != null) {
//           await _secureStorage.write(key: 'user_data', value: jsonEncode(data['user']));
//         }
        
//         return true;
//       }
      
//       return false;
//     } catch (e) {
//       debugPrint('Error during registration: $e');
//       return false;
//     }
//   }
  
//   /// Sign in with Google
//   Future<GoogleSignInResult> signInWithGoogle() async {
//     try {
//       // Check if already signed in
//       final already = await _googleSignIn.isSignedIn();
//       if (already) await _googleSignIn.signOut();
      
//       // Attempt sign in
//       final user = await _googleSignIn.signIn();
//       if (user == null) {
//         return GoogleSignInResult(success: false, errorMessage: 'Sign-in canceled by user');
//       }
      
//       final auth = await user.authentication;
//       final verified = await _verifyGoogleSignInWithBackend(
//         idToken: auth.idToken,
//         accessToken: auth.accessToken,
//         email: user.email,
//       );
      
//       if (verified) {
//         return GoogleSignInResult(success: true, email: user.email);
//       } else {
//         return GoogleSignInResult(success: false, errorMessage: 'Server authentication failed');
//       }
//     } catch (e) {
//       return GoogleSignInResult(success: false, errorMessage: 'Google Sign-In error: $e');
//     }
//   }
  
//   Future<bool> _verifyGoogleSignInWithBackend({
//     required String? idToken,
//     required String? accessToken,
//     required String email,
//   }) async {
//     try {
//       final url = _uri('/auth/google');
      
//       final response = await http
//         .post(url, 
//           headers: {'Content-Type': 'application/json'},
//           body: jsonEncode({
//             'idToken': idToken,
//             'accessToken': accessToken,
//             'email': email,
//           }),
//         )
//         .timeout(const Duration(seconds: 10));
      
//       if (response.statusCode >= 200 && response.statusCode < 300) {
//         final data = jsonDecode(response.body);
//         await _secureStorage.write(key: 'auth_token', value: data['token'] ?? '');
//         if (data['user'] != null) {
//           await _secureStorage.write(key: 'user_data', value: jsonEncode(data['user']));
//         }
//         return true;
//       } else {
//         debugPrint('Backend verification failed: ${response.statusCode}');
//         return false;
//       }
//     } catch (e) {
//       debugPrint('Backend verification error: $e');
//       return false;
//     }
//   }
  
//   /// Sign out the current user
//   Future<void> signOut() async {
//     try {
//       if (await _googleSignIn.isSignedIn()) await _googleSignIn.signOut();
//       await _secureStorage.delete(key: 'auth_token');
//       await _secureStorage.delete(key: 'user_data');
//     } catch (e) {
//       debugPrint('Error during sign out: $e');
//     }
//   }
  
//   /// Check if user is authenticated
//   Future<bool> isAuthenticated() async {
//     final token = await _secureStorage.read(key: 'auth_token');
//     return token != null && token.isNotEmpty;
//   }
  
//   /// Get the current authentication token
//   Future<String?> getAuthToken() => _secureStorage.read(key: 'auth_token');
  
//   /// Get the current user data
//   Future<Map<String, dynamic>?> getUserData() async {
//     final raw = await _secureStorage.read(key: 'user_data');
//     if (raw == null) return null;
//     try {
//       return jsonDecode(raw) as Map<String, dynamic>;
//     } catch (_) {
//       debugPrint('Error decoding user data');
//       return null;
//     }
//   }
// }

// /// Class to handle Google Sign-In results
// class GoogleSignInResult {
//   final bool success;
//   final String? email;
//   final String? errorMessage;
  
//   GoogleSignInResult({
//     required this.success,
//     this.email,
//     this.errorMessage,
//   });
// }