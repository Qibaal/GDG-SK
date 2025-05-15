import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gemexplora/chat_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:shared_preferences/shared_preferences.dart';


class AuthPage extends StatefulWidget {
  const AuthPage({super.key});
  @override
  AuthPageState createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> with SingleTickerProviderStateMixin {
  bool _isLogin = true;
  late AnimationController animationController;
  late Animation<Offset> loginSlideAnimation;
  late Animation<Offset> signUpSlideAnimation;
  late Animation<double> loginOpacityAnimation;
  late Animation<double> signUpOpacityAnimation;
  late Animation<double> containerPositionAnimation;
  bool _showTitle = false;
  bool _showSubtitle = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _showTitle = true;
      });
    });

    // Munculkan subtitle setelah 1500ms
    Future.delayed(const Duration(milliseconds: 1200), () {
      setState(() {
        _showSubtitle = true;
      });
    });
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    // Initialize animations similar to previous implementation
    loginSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.5, 0),
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    ));
    
    loginOpacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    ));
    
    signUpSlideAnimation = Tween<Offset>(
      begin: const Offset(1.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    ));
    
    signUpOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
    ));
    containerPositionAnimation = Tween<double>(
      begin: 0.25,  // Initial position (25% from top)
      end: 0.15,    // End position (5% from top) - this will cover the header text
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void _toggleForm() {
    setState(() {
      _isLogin = !_isLogin;
      if (_isLogin) {
        animationController.reverse();
      } else {
        animationController.forward();
      }
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Stack(
          children: [
            // Green curved shape in top left
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(120),
                  ),
                ),
              ),
            ),

            // Header Text
            Positioned(
              top: 200,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedOpacity(
                    opacity: _showTitle ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: Text(
                      'Hello!',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0077B6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  AnimatedOpacity(
                    opacity: _showSubtitle ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: Text(
                      'Welcome to Gem Explora',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF0077B6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedBuilder(
              animation: containerPositionAnimation,
              builder: (context, child) {
                return Positioned(
                  top: MediaQuery.of(context).size.height * (containerPositionAnimation.value+0.17),
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                child: Stack(
                  children: [
                    // Login Form
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: _isLogin 
                        ? SlideTransition(
                          position: loginSlideAnimation,
                          child: FadeTransition(
                            opacity: loginOpacityAnimation,
                            child: LoginForm(onSignUpPressed: _toggleForm),
                          ),
                        )
                      : SlideTransition(
                          position: signUpSlideAnimation,
                          child: FadeTransition(
                            opacity: signUpOpacityAnimation,
                            child: SignUpForm(onLoginPressed: _toggleForm),
                          ),
                        ),
                    ),
                  ],
                ),
              ),
            );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  final VoidCallback onSignUpPressed;

  const LoginForm({super.key, required this.onSignUpPressed});

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

  // Future<void> _handleAppleSignIn() async {
  //   try {
  //     final credential = await SignInWithApple.getAppleIDCredential(
  //       scopes: [
  //         AppleIDAuthorizationScopes.email,
  //         AppleIDAuthorizationScopes.fullName,
  //       ],
  //     );

  //     print('Apple ID: ${credential.userIdentifier}');
  //     print('Email: ${credential.email}');

  //     // Jika pakai Firebase:
  //     // final oAuthProvider = OAuthProvider("apple.com");
  //     // final firebaseCredential = oAuthProvider.credential(
  //     //   idToken: credential.identityToken,
  //     //   accessToken: credential.authorizationCode,
  //     // );
  //     // await FirebaseAuth.instance.signInWithCredential(firebaseCredential);

  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (_) => const HomeScreen()),
  //     );
  //   } catch (e) {
  //     print('Apple Sign-In error: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Apple Sign-In failed: $e')),
  //     );
  //   }
  // }

  late final GoogleSignIn _googleSignIn;

  @override
  void initState() {
    super.initState();
    
    // Initialize Google Sign-In with platform-specific settings
    if (kIsWeb) {
      // Web requires clientId
      _googleSignIn = GoogleSignIn(
        clientId: '112571618899-53i2orp47rs7m50rr160g27aeu5tjg7b.apps.googleusercontent.com', // Replace with your web client ID
        scopes: ['email', 'profile'],
      );
    } else {
      // Mobile platforms (Android/iOS) get client ID from Google services config files
      _googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );
    }
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      print('Starting Google Sign-In process');
      
      // Check if already signed in - might help diagnose issues
      final bool isSignedIn = await _googleSignIn.isSignedIn();
      print('Already signed in: $isSignedIn');
      
      if (isSignedIn) {
        // Try to sign out first to prevent cached credentials issues
        await _googleSignIn.signOut();
        print('Signed out existing session');
      }

      // Show loading indicator for Google Sign-In
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );
      }
      
      print('Displaying sign-in dialog');
      
      // Attempt sign in
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      // Close loading indicator immediately after sign-in dialog closes
      if (mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
      
      if (googleUser == null) {
        // User canceled the sign-in flow
        print('Google Sign-In canceled by user');
        return;
      }

      print('User selected account: ${googleUser.email}');
      
      // Show a new loading indicator for authentication process
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Completing authentication...', style: TextStyle(color: Colors.white)),
                ],
              ),
            );
          },
        );
      }

      // Get authentication details
      print('Getting authentication tokens');
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;
      final String? accessToken = googleAuth.accessToken;
      
      if (idToken != null && idToken.isNotEmpty) {
        print('ID Token received: ${idToken.substring(0, min(10, idToken.length))}...');
      } else {
        print('Warning: idToken is null or empty');
      }
      
      if (accessToken != null && accessToken.isNotEmpty) {
        print('Access Token received: ${accessToken.substring(0, min(10, accessToken.length))}...');
      } else {
        print('Warning: accessToken is null or empty');
      }
      
      // FOR TESTING ONLY: Skip backend verification during development
      // Remove this section when your backend is ready
      print('DEVELOPMENT MODE: Skipping backend verification');
      
      // Close loading indicator
      if (mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
      
      // Navigate to home screen directly (TEMPORARY for testing)
      // if (mounted) {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (_) => const HomeScreen()),
      //   );
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Google Sign-In Successful (Dev Mode)')),
      //   );
      // }
      
      // Comment out the backend verification for now
      // Verify with your backend server
      try {
        
        final bool backendVerified = await _verifyWithBackend(
          idToken: idToken,
          accessToken: accessToken,
          email: googleUser.email,
        );
        
        // Close loading indicator after verification
        if (mounted && Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
        
        print('Backend verification result: $backendVerified');
        
        if (backendVerified) {
          // Navigate to home screen on success
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login Successful')),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Server authentication failed')),
            );
          }
        }
      } catch (backendError) {
        // Close loading indicator if error occurs
        if (mounted && Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
        
        print('Backend verification error: $backendError');
        
        if (mounted) {
          final errorMessage = backendError.toString().replaceFirst('Exception: ', '');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Server error: $errorMessage')),
          );
        }
      }
    } catch (e) {
      // Close loading indicator if still showing
      if (mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
      
      print('Google Sign-In error: $e');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google Sign-In failed: ${e.toString()}')),
        );
      }
    }
  }

  // Updated _verifyWithBackend method with proper emulator URL
  Future<bool> _verifyWithBackend({
    required String? idToken,
    required String? accessToken,
    required String email,
  }) async {
    try {
      // Use 10.0.2.2 for Android emulator to access host machine's localhost
      // Use localhost for iOS simulator
      // const String backendBaseUrl = kIsWeb
      // ? 'http://localhost:8081'
      // : 'http://192.168.1.10:8081';
      final backendBaseUrl = await getBackendBaseUrl();
      final Uri backendUrl = Uri.parse('$backendBaseUrl/auth/google');
      
      print('Sending verification request to backend: $backendUrl');
      
      final response = await http.post(
        backendUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'idToken': idToken,
          'accessToken': accessToken,
          'email': email,
        }),
      ).timeout(const Duration(seconds: 10)); // Add timeout to avoid hanging
      
      print('Backend response status: ${response.statusCode}');
      print('Backend response body: ${response.body}');
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Parse and store any tokens/user data your server returns
        final responseData = jsonDecode(response.body);
        print('Successfully parsed response data');
        
        // Store the JWT or session token your server provides
        final secureStorage = FlutterSecureStorage();
        await secureStorage.write(
          key: 'auth_token', 
          value: responseData['token'] ?? '',
        );
        print('Token stored securely');
        
        return true;
      } else {
          final responseData = jsonDecode(response.body);
          final errorMessage = responseData['error'] ?? 'Unknown error from server';
          throw Exception(errorMessage); // lempar error ke catch block
      }
    } catch (e) {
      print('Backend verification error details: $e');
      // More specific error handling
      if (e is SocketException) {
        print('Socket error - likely server connection issue or wrong address');
      } else if (e is TimeoutException) {
        print('Request timed out - server might be unreachable');
      } else if (e is FormatException) {
        print('Format error - could not parse server response');
      }
      return false;
    }
  }

  Future<String> getBackendBaseUrl() async {
    if (kIsWeb) {
      return 'http://localhost:8081';
    }

    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;

      if (!androidInfo.isPhysicalDevice) {
        return 'http://localhost:8081'; // emulator
      } else {
        return 'http://192.168.1.10:8081'; // IP lokal dari laptop (seusuain ama ip laptop masing20)
      }
    }

    // Platform lain (iOS, Windows, macOS, Linux)
    return 'http://localhost:8081';
  }

  Future<void> _handleLogin() async {
    // Login logic remains the same as in your original implementation
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;
    // const String backendBaseUrl = kIsWeb
    // ? 'http://localhost:8081'
    // : 'http://192.168.1.10:8081';
    final backendBaseUrl = await getBackendBaseUrl();
    final Uri url = Uri.parse('$backendBaseUrl/login');

    try {
      final http.Response response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (!mounted) return;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Successful')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${response.body}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Login',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Email Input
            buildInputField(
              controller: _emailController,
              hintText: 'Email',
              prefixIcon: Icons.email_outlined,
            ),
            
            const SizedBox(height: 16),
            
            // Password Input
            buildInputField(
              controller: _passwordController,
              hintText: 'Password',
              prefixIcon: Icons.lock_outlined,
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
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
                  'Forgot Password',
                  style: TextStyle(
                    color: Color(0xFF858C95),
                    fontWeight: FontWeight.w600),
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Login Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0077B6),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text('Login',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 25),
            
            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Or login with',
                    style: TextStyle(
                      color: Color(0xFF858C95),
                      fontSize: 14,
                    ),
                  ),
                ),
                Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
              ],
            ),

            const SizedBox(height: 25),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _handleGoogleSignIn, // pastikan ini ada
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Image.asset(
                    'assets/google.png',
                    height: 24,
                    width: 24,
                  ),
                ),
                const SizedBox(width: 16),
                // ElevatedButton(
                //   onPressed: _handleAppleSignIn, // pastikan ini juga ada
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.white,
                //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(8),
                //     ),
                //     elevation: 0,
                //   ),
                //   child: Image.asset(
                //     'assets/apple.png',
                //     height: 24,
                //     width: 24,
                //   ),
                // ),
              ],
            ),
          
          const SizedBox(height: 24),
            // Sign Up Option
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Don\'t have an account? ',
                  style:TextStyle(
                    color: Color(0xFF858c95),
                  )
                ),
                GestureDetector(
                  onTap: widget.onSignUpPressed,
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Color(0xFF00B4D8),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  final VoidCallback onLoginPressed;

  const SignUpForm({super.key, required this.onLoginPressed});

  @override
  SignUpFormState createState() => SignUpFormState();
}

class SignUpFormState extends State<SignUpForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;
    
    // const String backendBaseUrl = kIsWeb
    //   ? 'http://localhost:8081'
    //   : 'http://192.168.1.10:8081';
    final backendBaseUrl = await getBackendBaseUrl();
    final Uri backendUrl = Uri.parse('$backendBaseUrl/register');
    try {
      final response = await http.post(
        backendUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailController.text,
          'password': _passwordController.text,
          
        }),
      );
      
      if (!mounted) return;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration Successful')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: ${response.body}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

    Future<String> getBackendBaseUrl() async {
    if (kIsWeb) {
      return 'http://localhost:8081';
    }

    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;

      if (!androidInfo.isPhysicalDevice) {
        return 'http://localhost:8081'; // emulator
      } else {
        return 'http://192.168.1.10:8081'; // IP lokal dari laptop (seusuain ama ip laptop masing20)
      }
    }

    // Platform lain (iOS, Windows, macOS, Linux)
    return 'http://localhost:8081';
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: widget.onLoginPressed,
                child: Row(
                  children:  [
                    Icon(Icons.arrow_back_ios, color: Color(0xFF006D7E)),
                    Text(
                      'Back to Login',
                      style: TextStyle(
                        color: Color(0xFF023E8A),
                        fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Email Input
              buildInputField(
                controller: _emailController,
                hintText: 'Email',
                prefixIcon: Icons.email_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Password Input
              buildInputField(
                controller: _passwordController,
                hintText: 'Password',
                prefixIcon: Icons.lock_outlined,
                obscureText: _obscurePassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password should be at least 6 characters';
                  }
                  return null;
                },
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Confirm Password Input
              buildInputField(
                controller: _confirmPasswordController,
                hintText: 'Confirm Password',
                prefixIcon: Icons.lock_outlined,
                obscureText: _obscureConfirmPassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
              ),
                          
              
              const SizedBox(height: 40),
              
              // Sign Up Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _registerUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0077B6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Helper function for input fields
Widget buildInputField({
  required TextEditingController controller,
  required String hintText,
  required IconData prefixIcon,
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
    style: TextStyle(
      fontSize: 16,
      color: Colors.black87,
    ),
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey[400]),
      prefixIcon: Icon(prefixIcon, color: const Color(0xFF006D7E), size: 20),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(
          color: Color(0xFF006D7E),
          width: 1,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1,
        ),
      ),
    ),
  );
}

Widget buildSocialLoginButton(String imagePath, Color borderColor) {
  return Container(
    width: 60,
    height: 45,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: Colors.grey[200]!,
        width: 1,
      ),
    ),
    child: Center(
      child: Image.asset(
        imagePath,
        height: 24,
        width: 24,
      ),
    ),
  );
}