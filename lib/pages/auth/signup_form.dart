// lib/pages/auth/signup_form.dart

import 'package:flutter/material.dart';
import 'package:gemexplora/chat_screen.dart';
import 'package:provider/provider.dart';
import 'package:gemexplora/providers/auth_provider.dart';
import 'package:gemexplora/widgets/input_field.dart';
import 'package:gemexplora/widgets/social_button.dart';

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
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create Account',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFFEEF2F7),
              ),
            ),
            const SizedBox(height: 30),

            // Full Name
            InputField(
              controller: _nameController,
              hintText: 'Full Name',
              prefixIcon: Icons.person_outlined,
              validator: (value) =>
                  (value == null || value.isEmpty) ? 'Please enter your name' : null,
            ),

            const SizedBox(height: 16),

            // Email
            InputField(
              controller: _emailController,
              hintText: 'Email',
              prefixIcon: Icons.email_outlined,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter your email';
                final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!regex.hasMatch(value)) return 'Please enter a valid email';
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
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter a password';
                if (value.length < 6) return 'Password should be at least 6 characters';
                return null;
              },
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: const Color(0xFFE0E6FF),
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),

            const SizedBox(height: 16),

            // Confirm Password
            InputField(
              controller: _confirmPasswordController,
              hintText: 'Confirm Password',
              prefixIcon: Icons.lock_outlined,
              obscureText: _obscureConfirmPassword,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please confirm your password';
                if (value != _passwordController.text) return 'Passwords do not match';
                return null;
              },
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                  color: const Color(0xFFE0E6FF),
                ),
                onPressed: () =>
                    setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
              ),
            ),

            const SizedBox(height: 24),

            // Sign Up Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  final authProvider =
                      Provider.of<AuthProvider>(context, listen: false);

                  final success = await authProvider.register(
                    name: _nameController.text.trim(),
                    email: _emailController.text.trim(),
                    password: _passwordController.text,
                  );

                  if (success) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChangeNotifierProvider<AuthProvider>.value(
                          value: authProvider,
                          child: const ChatScreen(),
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          authProvider.errorMessage ?? 'Registration failed',
                        ),
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
                  'SIGN UP',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Already have an account?
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account? ',
                    style: TextStyle(color: Color(0xFFEEF2F7))),
                GestureDetector(
                  onTap: widget.onLoginPressed,
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color: Color(0xFF4A90E2),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Or Sign Up With
            Row(
              children: [
                const Expanded(
                  child: Divider(
                    color: Color.fromARGB(255, 95, 93, 255),
                    thickness: 1,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'Or Sign Up With',
                    style: TextStyle(color: Color(0xFFEEF2F7), fontSize: 14),
                  ),
                ),
                const Expanded(
                  child: Divider(
                    color: Color.fromARGB(255, 95, 93, 255),
                    thickness: 1,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Social Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SocialButton('assets/google.png'),
                const SizedBox(width: 20),
                SocialButton('assets/apple.png'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
