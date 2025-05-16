// import 'dart:async';
// // import 'dart:io';
// // import 'dart:math';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// // import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:gemexplora/chat_screen.dart';
// // import 'package:google_sign_in/google_sign_in.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';
// // import 'package:gemexplora/utils/backend_config.dart';
// import 'package:gemexplora/services/auth_service.dart';
// import 'package:gemexplora/widgets/input_fields.dart';


// class LoginForm extends StatefulWidget {
//   final VoidCallback onSignUpPressed;

//   const LoginForm({super.key, required this.onSignUpPressed});

//   @override
//   LoginFormState createState() => LoginFormState();
// }

// class LoginFormState extends State<LoginForm> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _obscurePassword = true;
//   final _authService = AuthService();

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> _handleGoogleSignIn() async {
//     try {
//       // Show loading indicator for Google Sign-In
//       if (mounted) {
//         showDialog(
//           context: context,
//           barrierDismissible: false,
//           builder: (BuildContext context) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           },
//         );
//       }
      
//       // Use the AuthService to perform Google Sign-In
//       final result = await _authService.signInWithGoogle();
      
//       // Close loading indicator
//       if (mounted && Navigator.canPop(context)) {
//         Navigator.of(context).pop();
//       }
      
//       if (!result.success) {
//         // Show error message if sign-in failed
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(result.errorMessage ?? 'Google Sign-In failed')),
//           );
//         }
//         return;
//       }
      
//       // On success, navigate to home screen
//       if (mounted) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const HomeScreen()),
//         );
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Login Successful')),
//         );
//       }
//     } catch (e) {
//       // Close loading indicator if error occurs
//       if (mounted && Navigator.canPop(context)) {
//         Navigator.of(context).pop();
//       }
      
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Google Sign-In error: ${e.toString()}')),
//         );
//       }
//     }
//   }

//   Future<void> _handleLogin() async {
//     final String email = _emailController.text.trim();
//     final String password = _passwordController.text;
    
//     // Show loading indicator
//     if (mounted) {
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         },
//       );
//     }
    
//     // Use the AuthService to perform email/password login
//     final success = await _authService.signInWithEmailAndPassword(email, password);
    
//     // Close loading indicator
//     if (mounted && Navigator.canPop(context)) {
//       Navigator.of(context).pop();
//     }
    
//     if (!mounted) return;
    
//     if (success) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const HomeScreen()),
//       );
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Login Successful')),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Login failed: Invalid email or password')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(24.0),
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Login',
//               style: TextStyle(
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//                 color: Color.fromARGB(255, 0, 0, 0),
//               ),
//             ),
            
//             const SizedBox(height: 30),
            
//             // Email Input - using the InputDecorations utility
//             buildInputField(
//               controller: _emailController,
//               hintText: 'Email',
//               prefixIcon: Icons.email_outlined,
//             ),
            
//             const SizedBox(height: 16),
            
//             // Password Input - using the InputDecorations utility
//             buildInputField(
//               controller: _passwordController,
//               hintText: 'Password',
//               prefixIcon: Icons.lock_outlined,
//               obscureText: _obscurePassword,
//               suffixIcon: IconButton(
//                 icon: Icon(
//                   _obscurePassword ? Icons.visibility_off : Icons.visibility,
//                   color: Colors.grey,
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     _obscurePassword = !_obscurePassword;
//                   });
//                 },
//               ),
//             ),
            
//             Align(
//               alignment: Alignment.centerRight,
//               child: TextButton(
//                 onPressed: () {},
//                 child: const Text(
//                   'Forgot Password',
//                   style: TextStyle(
//                     color: Color(0xFF858C95),
//                     fontWeight: FontWeight.w600),
//                 ),
//               ),
//             ),
            
//             const SizedBox(height: 30),
            
//             // Login Button
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: _handleLogin,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF0077B6),
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                 ),
//                 child: const Text('Login',
//                   style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
            
//             const SizedBox(height: 25),
            
//             Row(
//               children: [
//                 Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
//                 const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 16),
//                   child: Text(
//                     'Or login with',
//                     style: TextStyle(
//                       color: Color(0xFF858C95),
//                       fontSize: 14,
//                     ),
//                   ),
//                 ),
//                 Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
//               ],
//             ),

//             const SizedBox(height: 25),

//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton(
//                   onPressed: _handleGoogleSignIn,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     elevation: 0,
//                   ),
//                   child: Image.asset(
//                     'assets/google.png',
//                     height: 24,
//                     width: 24,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//               ],
//             ),
          
//             const SizedBox(height: 24),
            
//             // Sign Up Option
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text(
//                   'Don\'t have an account? ',
//                   style: TextStyle(
//                     color: Color(0xFF858c95),
//                   )
//                 ),
//                 GestureDetector(
//                   onTap: widget.onSignUpPressed,
//                   child: const Text(
//                     'Sign Up',
//                     style: TextStyle(
//                       color: Color(0xFF00B4D8),
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }