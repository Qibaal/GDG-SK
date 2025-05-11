import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gemexplora/chat_screen.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: const AuthScreen(),
//     );
//   }
// }

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});
  @override
  AuthPageState createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> with SingleTickerProviderStateMixin {
  bool _isLogin = true;
  late AnimationController _animationController;
  late Animation<Offset> _loginSlideAnimation;
  late Animation<Offset> _signUpSlideAnimation;
  late Animation<double> _loginOpacityAnimation;
  late Animation<double> _signUpOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    // Animations for login form
    _loginSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.5, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _loginOpacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    ));
    
    // Animations for signup form
    _signUpSlideAnimation = Tween<Offset>(
      begin: const Offset(1.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _signUpOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleForm() {
    setState(() {
      if (_isLogin) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
      _isLogin = !_isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body: Center(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/shibuya.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center( // Tambahkan Center di sini
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Pastikan posisi vertikal center
                  children: [
                    // Logo dan judul bisa tetap di sini
                    
                    const SizedBox(height: 30),
                    
                    // Form Container dengan design yang fleksibel
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: double.infinity,
                      height: _isLogin ? 530 : 650,
                      decoration: BoxDecoration(
                        color: Color(0xAA1A1E35),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Color(0x334A90E2),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha((0.1*255).toInt()),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        
                          child: Stack(
                            children: [
                              // Login Form
                              SlideTransition(
                                position: _loginSlideAnimation,
                                child: FadeTransition(
                                  opacity: _loginOpacityAnimation,
                                  child: LoginForm(
                                    isVisible: _isLogin,
                                    onSignUpPressed: _toggleForm,
                                  ),
                                ),
                              ),
                              
                              // Sign Up Form
                              SlideTransition(
                                position: _signUpSlideAnimation,
                                child: FadeTransition(
                                  opacity: _signUpOpacityAnimation,
                                  child: SignUpForm(
                                    isVisible: !_isLogin,
                                    onLoginPressed: _toggleForm,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    // Social Media Login atau konten lainnya
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  }
}

class LoginForm extends StatefulWidget {
  final bool isVisible;
  final VoidCallback onSignUpPressed;

  const LoginForm({
    super.key,
    required this.isVisible,
    required this.onSignUpPressed,
  });

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Login',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFFEEF2F7),
            ),
          ),
          const SizedBox(height: 30),
          
          // Email Input
          buildTextFormField(
            controller: _emailController,
            labelText: 'Email',
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
          ),
          
          const SizedBox(height: 16),
          
          // Password Input - Simplified design
          buildTextFormField(
            controller: _passwordController,
            labelText: 'Password',
            icon: Icons.lock,
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: Color(0xFFE0E6FF),
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
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
          
          // Login Button - Simplified style
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                final email = _emailController.text;
                final password = _passwordController.text;

                final url = Uri.parse('http://localhost:8080/login');
                final response = await http.post(
                  url,
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode({'email': email, 'password': password}),
                );

                if (response.statusCode >= 200 && response.statusCode < 300) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()), // Or HomeScreen()
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Login failed: ${response.body}')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
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
          
          // Don't have an account text
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Don\'t have an account? ',
                style: TextStyle(
                  color: Color(0xFFEEF2F7),
                ),
              ),
              GestureDetector(
                onTap: widget.onSignUpPressed,
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Color(0xFF4A90E2),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 30),
          
          // Or Sign In With section
          Row(
            children: [
              Expanded(child: Divider(color: const Color.fromARGB(255, 95, 93, 255), thickness: 1)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Or Sign In With',
                  style: TextStyle(
                    color: Color(0xFFEEF2F7),
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(child: Divider(color: const Color.fromARGB(255, 95, 93, 255), thickness: 1)),
              
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildSocialButton('assets/google.png'),
              const SizedBox(width: 20),
              buildSocialButton('assets/apple.png'),
            ],
          ),
              
        ],
      ),
    );
  }
  
}
class SignUpForm extends StatefulWidget {
  final bool isVisible;
  final VoidCallback onLoginPressed;

  const SignUpForm({
    super.key,
    required this.isVisible,
    required this.onLoginPressed,
  });

  @override
  SignUpFormState createState() => SignUpFormState();
}

class SignUpFormState extends State<SignUpForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    final url = Uri.parse('http://localhost:8080/register'); // Replace with your local IP if on device
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful. Please log in.')),
      );
      widget.onLoginPressed(); // This switches to login view
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: ${response.body}')),
      );
    }
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
            Text(
              'Create Account',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFFEEF2F7),
              ),
            ),
            const SizedBox(height: 30),

            buildTextFormField(
              controller: _nameController,
              labelText: 'Full Name',
              icon: Icons.person,
              validator: (value) =>
                  value == null || value.isEmpty ? 'Please enter your name' : null,
            ),

            const SizedBox(height: 16),

            buildTextFormField(
              controller: _emailController,
              labelText: 'Email',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter your email';
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            buildTextFormField(
              controller: _passwordController,
              labelText: 'Password',
              icon: Icons.lock,
              obscureText: _obscurePassword,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter a password';
                if (value.length < 6) return 'Password should be at least 6 characters';
                return null;
              },
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Color(0xFFE0E6FF),
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),

            const SizedBox(height: 16),

            buildTextFormField(
              controller: _confirmPasswordController,
              labelText: 'Confirm Password',
              icon: Icons.lock,
              obscureText: _obscureConfirmPassword,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please confirm your password';
                if (value != _passwordController.text) return 'Passwords do not match';
                return null;
              },
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                  color: Color(0xFFE0E6FF),
                ),
                onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _registerUser();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
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

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account? ', style: TextStyle(color: Color(0xFFEEF2F7))),
                GestureDetector(
                  onTap: widget.onLoginPressed,
                  child: Text('Login',
                      style: TextStyle(color: Color(0xFF4A90E2), fontWeight: FontWeight.bold)),
                ),
              ],
            ),

            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(child: Divider(color: Color.fromARGB(255, 95, 93, 255), thickness: 1)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('Or Sign Up With',
                      style: TextStyle(color: Color(0xFFEEF2F7), fontSize: 14)),
                ),
                Expanded(child: Divider(color: Color.fromARGB(255, 95, 93, 255), thickness: 1)),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildSocialButton('assets/google.png'),
                const SizedBox(width: 20),
                buildSocialButton('assets/apple.png'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(
        fontSize: 16,
        color: Color(0xFFE0E6FF),
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Color(0xFFE0E6FF)),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        floatingLabelStyle: TextStyle(color: Colors.blue[700], fontWeight: FontWeight.w500),
        prefixIcon: Icon(icon, color: Color(0xFFE0E6FF)),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Color(0x40202442),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue[700]!, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.red[400]!, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue[700]!, width: 1.5),
        ),
        
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
}
Widget buildSocialButton(String imagePath) {
  return ElevatedButton(
    onPressed: () {
    },
    style: ElevatedButton.styleFrom(
      shape: const CircleBorder(),
      backgroundColor: Colors.white,
      padding: const EdgeInsets.all(12),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
    ),
    child: Image.asset(
      imagePath,
      width: 30,
      height: 30,
      fit: BoxFit.contain,
    ),
  );
}