// File: lib/widgets/auth_gate.dart

import 'package:flutter/material.dart';
import 'package:gemexplora/screens/auth/auth_page.dart';
import 'package:gemexplora/screens/home/home_screen.dart';
import 'package:gemexplora/services/auth_service.dart';

/// A gatekeeper widget that checks authentication status on startup.
/// - While checking, shows a loading indicator.
/// - If authenticated, navigates to HomeScreen.
/// - Otherwise, shows the AuthPage.
class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService().isAuthenticated(),
      builder: (context, snapshot) {
        // Still checking auth status
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Error occurred during check
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                'Error checking authentication:\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final isAuth = snapshot.data ?? false;

        // If authenticated, go straight to HomeScreen
        if (isAuth) {
          return const HomeScreen();
        }

        // Otherwise show the login/register page
        return const AuthPage();
      },
    );
  }
}
