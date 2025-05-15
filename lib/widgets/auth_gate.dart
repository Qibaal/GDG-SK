import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gemexplora/providers/auth_provider.dart';
import 'package:gemexplora/chat_screen.dart';
import 'package:gemexplora/login_signup.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return authProvider.isAuthenticated
        ? const ChatScreen()
        : const AuthPage();
  }
}
