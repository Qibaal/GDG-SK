import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isLogin = true;

  void _toggleMode() {
    setState(() => _isLogin = !_isLogin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? 'Sign In' : 'Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _isLogin ? _buildSignIn() : _buildSignUp(),
      ),
      bottomNavigationBar: TextButton(
        onPressed: _toggleMode,
        child: Text(_isLogin
            ? 'Belum punya akun? Sign Up'
            : 'Sudah punya akun? Sign In'),
      ),
    );
  }

  Widget _buildSignIn() {
    return Column(
      children: [
        TextField(decoration: const InputDecoration(labelText: 'Email')),
        TextField(
          decoration: const InputDecoration(labelText: 'Password'),
          obscureText: true,
        ),
        const SizedBox(height: 20),
        ElevatedButton(onPressed: () {}, child: const Text('Sign In')),
      ],
    );
  }

  Widget _buildSignUp() {
    return Column(
      children: [
        TextField(decoration: const InputDecoration(labelText: 'Name')),
        TextField(decoration: const InputDecoration(labelText: 'Email')),
        TextField(
          decoration: const InputDecoration(labelText: 'Password'),
          obscureText: true,
        ),
        const SizedBox(height: 20),
        ElevatedButton(onPressed: () {}, child: const Text('Sign Up')),
      ],
    );
  }
}
