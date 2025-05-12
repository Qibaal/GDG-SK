import 'package:flutter/material.dart';
import 'package:gemexplora/splash_screen.dart';
import 'package:gemexplora/provider_setup.dart';
import 'package:gemexplora/widgets/auth_gate.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    AppProviders( // ✅ wrap here
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GemExplora',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: SplashScreen(
        nextScreen: const AuthGate(),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
