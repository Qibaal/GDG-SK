import 'package:flutter/material.dart';
import 'package:gemexplora/widgets/splash_screen.dart';
import 'package:gemexplora/providers/provider_setup.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gemexplora/widgets/auth_gate.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'assets/.env');
  runApp(AppProviders(child: const MyApp()));
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
        nextScreen: const AuthGate(),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
