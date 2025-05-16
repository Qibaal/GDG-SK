// lib/pages/auth/login_form.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gemexplora/widgets/auth_gate.dart';
import 'package:gemexplora/providers/auth_provider.dart';
import 'package:gemexplora/widgets/input_field.dart';
import 'package:gemexplora/widgets/social_button.dart';

class LoginForm extends StatefulWidget {
  final bool isVisible;
  final VoidCallback onSignUpPressed;
  const LoginForm({
    Key? key,
    required this.isVisible,
    required this.onSignUpPressed,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text(
          'Login',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFFEEF2F7),
          ),
        ),
        const SizedBox(height: 30),
        InputField(
          controller: _emailCtrl,
          hintText: 'Email',
          prefixIcon: Icons.email_outlined,
        ),
        const SizedBox(height: 16),
        InputField(
          controller: _passCtrl,
          hintText: 'Password',
          prefixIcon: Icons.lock_outlined,
          obscureText: _obscure,
          suffixIcon: IconButton(
            icon: Icon(
              _obscure ? Icons.visibility_off : Icons.visibility,
              color: const Color(0xFFE0E6FF),
            ),
            onPressed: () => setState(() => _obscure = !_obscure),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: Text(
              'Forgot Password?',
              style: TextStyle(
                color: Colors.blue[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () async {
              final auth = context.read<AuthProvider>();
              final success = await auth.login(
                _emailCtrl.text.trim(),
                _passCtrl.text.trim(),
              );

              // Debug: print out the result
              debugPrint('🔥 login returned: $success');
              debugPrint('   token: ${auth.token}');
              // debugPrint('   user: ${auth.user}');

              if (!mounted) return;

              if (success) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const AuthGate()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(auth.errorMessage ?? 'Login failed'),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0077B6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'LOGIN',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 25),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text(
            'Don’t have an account? ',
            style: TextStyle(color: Color(0xFFEEF2F7)),
          ),
          GestureDetector(
            onTap: widget.onSignUpPressed,
            child: const Text(
              'Sign Up',
              style: TextStyle(
                color: Color(0xFF4A90E2),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ]),
        const SizedBox(height: 30),
        Row(children: [
          const Expanded(
            child: Divider(color: Color.fromARGB(255, 95, 93, 255)),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text('Or Sign In With',
                style: TextStyle(color: Color(0xFFEEF2F7))),
          ),
          const Expanded(
            child: Divider(color: Color.fromARGB(255, 95, 93, 255)),
          ),
        ]),
        const SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          SocialButton('assets/google.png'),
          const SizedBox(width: 20),
          SocialButton('assets/apple.png'),
        ]),
      ]),
    );
  }
}
