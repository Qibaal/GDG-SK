// import 'package:flutter/material.dart';
// import 'package:gemexplora/services/auth_service.dart';
// import '../../screens/home/home_screen.dart';
// import '../../widgets/input_fields.dart';



// class SignUpForm extends StatefulWidget {
//   final VoidCallback onLoginPressed;

//   const SignUpForm({super.key, required this.onLoginPressed});

//   @override
//   SignUpFormState createState() => SignUpFormState();
// }

// class SignUpFormState extends State<SignUpForm> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
  
//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;
//   final _formKey = GlobalKey<FormState>();
//   final AuthService _authService = AuthService();

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   Future<void> _registerUser() async {
//     if (!_formKey.currentState!.validate()) return;
    
//     try {
//       final success = await _authService.registerUser(
//         _emailController.text,
//         _passwordController.text,
//       );
      
//       if (!mounted) return;

//       if (success) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const HomeScreen()),
//         );
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Registration Successful')),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Registration failed: Email may already be in use')),
//         );
//       }
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//     }
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(24.0),
//       child: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               GestureDetector(
//                 onTap: widget.onLoginPressed,
//                 child: const Row(
//                   children: [
//                     Icon(Icons.arrow_back_ios, color: Color(0xFF006D7E)),
//                     Text(
//                       'Back to Login',
//                       style: TextStyle(
//                         color: Color(0xFF023E8A),
//                         fontWeight: FontWeight.w700),
//                     ),
//                   ],
//                 ),
//               ),
              
//               const SizedBox(height: 20),
              
//               const Text(
//                 'Sign Up',
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                   color: Color.fromARGB(255, 0, 0, 0),
//                 ),
//               ),
              
//               const SizedBox(height: 30),
              
//               // Email Input
//               buildInputField(
//                 controller: _emailController,
//                 hintText: 'Email',
//                 prefixIcon: Icons.email_outlined,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your email';
//                   }
//                   if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
//                     return 'Please enter a valid email';
//                   }
//                   return null;
//                 },
//               ),
              
//               const SizedBox(height: 16),
              
//               // Password Input
//               buildInputField(
//                 controller: _passwordController,
//                 hintText: 'Password',
//                 prefixIcon: Icons.lock_outlined,
//                 obscureText: _obscurePassword,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a password';
//                   }
//                   if (value.length < 6) {
//                     return 'Password should be at least 6 characters';
//                   }
//                   return null;
//                 },
//                 suffixIcon: IconButton(
//                   icon: Icon(
//                     _obscurePassword ? Icons.visibility_off : Icons.visibility,
//                     color: Colors.grey,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       _obscurePassword = !_obscurePassword;
//                     });
//                   },
//                 ),
//               ),
              
//               const SizedBox(height: 16),
              
//               // Confirm Password Input
//               buildInputField(
//                 controller: _confirmPasswordController,
//                 hintText: 'Confirm Password',
//                 prefixIcon: Icons.lock_outlined,
//                 obscureText: _obscureConfirmPassword,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please confirm your password';
//                   }
//                   if (value != _passwordController.text) {
//                     return 'Passwords do not match';
//                   }
//                   return null;
//                 },
//                 suffixIcon: IconButton(
//                   icon: Icon(
//                     _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
//                     color: Colors.grey,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       _obscureConfirmPassword = !_obscureConfirmPassword;
//                     });
//                   },
//                 ),
//               ),
                          
              
//               const SizedBox(height: 40),
              
//               // Sign Up Button
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: _registerUser,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF0077B6),
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                   child: const Text(
//                     'Sign Up',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }