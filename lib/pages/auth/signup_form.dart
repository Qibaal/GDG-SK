// lib/pages/auth/signup_form.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gemexplora/widgets/auth_gate.dart';
import 'package:gemexplora/providers/auth_provider.dart';
import 'package:gemexplora/widgets/input_field.dart';

class SignUpForm extends StatefulWidget {
  final bool isVisible;
  final VoidCallback onLoginPressed;

  const SignUpForm({
    Key? key,
    required this.isVisible,
    required this.onLoginPressed,
  }) : super(key: key);

  @override
  SignUpFormState createState() => SignUpFormState();
}

class SignUpFormState extends State<SignUpForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _handleGoogleSignIn() async {
    final auth = context.read<AuthProvider>();

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final success = await auth.signInWithGoogle();

    if (!mounted) return;
    Navigator.of(context).pop(); // Dismiss loading dialog

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthGate()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Successful')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.errorMessage ?? 'Google Sign-In failed')),
      );
    }
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final success = await auth.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthGate()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration Successful')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.errorMessage ?? 'Registration failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            GestureDetector(
              onTap: widget.onLoginPressed,
              child: const Row(
                children: [
                  Icon(Icons.arrow_back_ios, color: Color(0xFF006D7E)),
                  Text(
                    'Back to Login',
                    style: TextStyle(
                      color: Color(0xFF023E8A),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Sign Up',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000000),
              ),
            ),
            const SizedBox(height: 30),

            // Full Name
            InputField(
              controller: _nameController,
              hintText: 'Full Name',
              prefixIcon: Icons.person_outlined,
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Please enter your name' : null,
            ),
            const SizedBox(height: 16),

            // Email
            InputField(
              controller: _emailController,
              hintText: 'Email',
              prefixIcon: Icons.email_outlined,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Please enter your email';
                final re = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!re.hasMatch(v)) return 'Enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Password
            InputField(
              controller: _passwordController,
              hintText: 'Password',
              prefixIcon: Icons.lock_outlined,
              obscureText: _obscurePassword,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Please enter a password';
                if (v.length < 6) return 'Password should be at least 6 characters';
                return null;
              },
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            const SizedBox(height: 16),

            // Confirm Password
            InputField(
              controller: _confirmController,
              hintText: 'Confirm Password',
              prefixIcon: Icons.lock_outlined,
              obscureText: _obscureConfirm,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Please confirm your password';
                if (v != _passwordController.text) return 'Passwords do not match';
                return null;
              },
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
              ),
            ),
            const SizedBox(height: 40),

            // Sign Up Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0077B6),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Already have an account?
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text(
                'Already have an account? ',
                style: TextStyle(color: Color(0xFF858C95)),
              ),
              GestureDetector(
                onTap: widget.onLoginPressed,
                child: const Text(
                  'Login',
                  style: TextStyle(
                    color: Color(0xFF00B4D8),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 30),            
            
          ]),
        ),
      ),
    );
  }
}
