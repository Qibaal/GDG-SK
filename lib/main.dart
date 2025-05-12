import 'package:flutter/material.dart';
import 'package:gemexplora/login_signup.dart';
import 'package:gemexplora/splash_screen.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GemExplora',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(
        nextScreen: const AuthPage(),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}