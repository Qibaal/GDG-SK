import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class User {
  final String id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
  };
}

class AuthProvider with ChangeNotifier {
  String? _token;
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  String? get token => _token;
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _token != null;

  // Constructor to check for existing authentication on app start
  AuthProvider() {
    checkStoredAuth();
  }

  // Check for stored authentication when app launches
  Future<void> checkStoredAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('token');
    final storedUserJson = prefs.getString('user');

    if (storedToken != null && storedUserJson != null) {
      _token = storedToken;
      _user = User.fromJson(json.decode(storedUserJson));

      // Log here
      print('[RESTORE] Token from SharedPreferences: $_token');
      print('[RESTORE] User: ${_user?.toJson()}');

      notifyListeners();
    }
  }

  // Login method
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final url = Uri.parse('${dotenv.env['API_BASE_URL']}/login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300 && data['token'] != null) {
        // Store token and user info
        _token = data['token'];
        _user = User.fromJson(data['user']);

        // Log here
        print('[LOGIN] Token set: $_token');
        print('[LOGIN] User: ${_user?.toJson()}');

        // Save to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        await prefs.setString('user', jsonEncode(_user!.toJson()));

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = data['message'] ?? 'Login failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'An error occurred. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Register method
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final registerUrl = Uri.parse('${dotenv.env['API_BASE_URL']}/register');
      final registerResponse = await http.post(
        registerUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (registerResponse.statusCode >= 200 && registerResponse.statusCode < 300) {
        // Attempt to log in after successful registration
        return await login(email, password);
      } else {
        final data = jsonDecode(registerResponse.body);
        _errorMessage = data['message'] ?? 'Registration failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'An error occurred during registration. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout method
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');

    _token = null;
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }

  // Method to check token validity (optional - you might want to implement this with your backend)
  Future<bool> validateToken() async {
    if (_token == null) return false;

    try {
      final url = Uri.parse('${dotenv.env['API_BASE_URL']}/validate-token');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        // Token is invalid, log out
        await logout();
        return false;
      }
    } catch (e) {
      await logout();
      return false;
    }
  }
}