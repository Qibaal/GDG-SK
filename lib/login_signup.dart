// import 'package:flutter/material.dart';
// import 'package:gemexplora/pages/chat/chat_screen.dart';
// import 'package:gemexplora/providers/auth_provider.dart';
// import 'package:provider/provider.dart';

// class AuthPage extends StatefulWidget {
//   const AuthPage({super.key});
//   @override
//   AuthPageState createState() => AuthPageState();
// }

// class AuthPageState extends State<AuthPage> with SingleTickerProviderStateMixin {
//   bool _isLogin = true;
//   bool _showTitle = false;
//   bool _showSubtitle = false;
//   late Animation<double> _containerPositionAnimation;
//   late AnimationController _animationController;
//   late Animation<Offset> _loginSlideAnimation;
//   late Animation<Offset> _signUpSlideAnimation;
//   late Animation<double> _loginOpacityAnimation;
//   late Animation<double> _signUpOpacityAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
    
//     // Animations for login form
//     _loginSlideAnimation = Tween<Offset>(
//       begin: Offset.zero,
//       end: const Offset(-1.5, 0),
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     ));
    
//     _loginOpacityAnimation = Tween<double>(
//       begin: 1.0,
//       end: 0.0,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
//     ));
    
//     // Animations for signup form
//     _signUpSlideAnimation = Tween<Offset>(
//       begin: const Offset(1.5, 0),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     ));
    
//     _signUpOpacityAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
//     ));

//     // trigger header fade-in
//     Future.delayed(const Duration(milliseconds: 500), () {
//       setState(() => _showTitle = true);
//     });
//     Future.delayed(const Duration(milliseconds: 1200), () {
//       setState(() => _showSubtitle = true);
//     });

//     // panel slide up a bit to make room for header
//     _containerPositionAnimation = Tween<double>(
//       begin: 0.25,  // 25% from top
//       end:   0.15,  // 15% from top
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     ));
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   void _toggleForm() {
//     setState(() {
//       if (_isLogin) {
//         _animationController.forward();
//       } else {
//         _animationController.reverse();
//       }
//       _isLogin = !_isLogin;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Stack(
//           children: [
//             // 2) Green curved header shape
//             Positioned(
//               top: 0,
//               left: 0,
//               child: Container(
//                 width: 120,
//                 height: 120,
//                 decoration: const BoxDecoration(
//                   color: Color(0xFFF5F5F5),
//                   borderRadius: BorderRadius.only(
//                     bottomRight: Radius.circular(120),
//                   ),
//                 ),
//               ),
//             ),

//             // 3) Animated “Hello!” + subtitle
//             Positioned(
//               top: 200,
//               // top: MediaQuery.of(context).size.height * 0.15,
//               left: 20,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   AnimatedOpacity(
//                     opacity: _showTitle ? 1.0 : 0.0,
//                     duration: const Duration(milliseconds: 500),
//                     child: const Text(
//                       'Hello!',
//                       style: TextStyle(
//                         fontSize: 32,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF0077B6),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   AnimatedOpacity(
//                     opacity: _showSubtitle ? 1.0 : 0.0,
//                     duration: const Duration(milliseconds: 500),
//                     child: const Text(
//                       'Welcome to GemExplora',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w500,
//                         color: Color(0xFF0077B6),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // 4) Sliding panel (login/signup)
//             AnimatedBuilder(
//               animation: _containerPositionAnimation,
//               builder: (context, child) {
//                 final topOffset = MediaQuery.of(context).size.height *
//                     _containerPositionAnimation.value;
//                 return Positioned(
//                   top: topOffset,
//                   left: 0,
//                   right: 0,
//                   bottom: 0,
//                   child: Container(
//                     // decoration: BoxDecoration(
//                     //   color: const Color(0xAA1A1E35),
//                     //   borderRadius: const BorderRadius.only(
//                     //     topLeft: Radius.circular(20),
//                     //     topRight: Radius.circular(20),
//                     //   ),
//                     //   border: Border.all(
//                     //     color: const Color(0x334A90E2),
//                     //     width: 1.5,
//                     //   ),
//                     //   boxShadow: [
//                     //     BoxShadow(
//                     //       color: Colors.black.withAlpha((0.1 * 255).toInt()),
//                     //       blurRadius: 10,
//                     //       spreadRadius: 1,
//                     //     ),
//                     //   ],
//                     // ),
//                     decoration: const BoxDecoration(
//                       color: Color(0xFFF5F5F5),
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(30),
//                         topRight: Radius.circular(30),
//                       ),
//                     ),
//                     child: ClipRRect(
//                       borderRadius: const BorderRadius.only(
//                         topLeft: Radius.circular(20),
//                         topRight: Radius.circular(20),
//                       ),
//                       child: Stack(
//                         children: [
//                           // Login form
//                           SlideTransition(
//                             position: _loginSlideAnimation,
//                             child: FadeTransition(
//                               opacity: _loginOpacityAnimation,
//                               child: LoginForm(
//                                 isVisible: _isLogin,
//                                 onSignUpPressed: _toggleForm,
//                               ),
//                             ),
//                           ),
//                           // Sign-up form
//                           SlideTransition(
//                             position: _signUpSlideAnimation,
//                             child: FadeTransition(
//                               opacity: _signUpOpacityAnimation,
//                               child: SignUpForm(
//                                 isVisible: !_isLogin,
//                                 onLoginPressed: _toggleForm,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class LoginForm extends StatefulWidget {
//   final bool isVisible;
//   final VoidCallback onSignUpPressed;

//   const LoginForm({
//     super.key,
//     required this.isVisible,
//     required this.onSignUpPressed,
//   });

//   @override
//   LoginFormState createState() => LoginFormState();
// }

// class LoginFormState extends State<LoginForm> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _obscurePassword = true;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(24.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Login',
//             style: TextStyle(
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFFEEF2F7),
//             ),
//           ),
//           const SizedBox(height: 30),
          
//           // Email Input
//           buildInputField(
//             controller: _emailController,
//             hintText: 'Email',
//             prefixIcon: Icons.email_outlined,
//           ),
          
//           const SizedBox(height: 16),
          
//           // Password Input - Simplified design
//           buildInputField(
//             controller: _passwordController,
//             hintText: 'Password',
//             prefixIcon: Icons.lock_outlined,
//             obscureText: _obscurePassword,
//             suffixIcon: IconButton(
//               icon: Icon(
//                 _obscurePassword ? Icons.visibility_off : Icons.visibility,
//                 color: Color(0xFFE0E6FF),
//               ),
//               onPressed: () {
//                 setState(() {
//                   _obscurePassword = !_obscurePassword;
//                 });
//               },
//             ),
//           ),
          
//           Align(
//             alignment: Alignment.centerRight,
//             child: TextButton(
//               onPressed: () {},
//               child: Text(
//                 'Forgot Password?',
//                 style: TextStyle(
//                   color: Colors.blue[700],
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
          
//           const SizedBox(height: 20),
          
//           SizedBox(
//             width: double.infinity,
//             height: 50,
//             child: ElevatedButton(
//               onPressed: () async {
//                 final authProvider = Provider.of<AuthProvider>(context, listen: false);

//                 final email = _emailController.text.trim();
//                 final password = _passwordController.text.trim();

//                 final success = await authProvider.login(email, password);

//                 if (success) {
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ChangeNotifierProvider<AuthProvider>.value(
//                         value: Provider.of<AuthProvider>(context, listen: false),
//                         child: const ChatScreen(),
//                       ),
//                     ),
//                   );
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text(authProvider.errorMessage ?? 'Login failed'),
//                     ),
//                   );
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF0077B6),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//               ),
//               child: const Text(
//                 'LOGIN',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
          
//           const SizedBox(height: 25),
          
//           // Don't have an account text
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Don\'t have an account? ',
//                 style: TextStyle(
//                   color: Color(0xFFEEF2F7),
//                 ),
//               ),
//               GestureDetector(
//                 onTap: widget.onSignUpPressed,
//                 child: Text(
//                   'Sign Up',
//                   style: TextStyle(
//                     color: Color(0xFF4A90E2),
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           ),
          
//           const SizedBox(height: 30),
          
//           // Or Sign In With section
//           Row(
//             children: [
//               Expanded(child: Divider(color: const Color.fromARGB(255, 95, 93, 255), thickness: 1)),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 8),
//                 child: Text(
//                   'Or Sign In With',
//                   style: TextStyle(
//                     color: Color(0xFFEEF2F7),
//                     fontSize: 14,
//                   ),
//                 ),
//               ),
//               Expanded(child: Divider(color: const Color.fromARGB(255, 95, 93, 255), thickness: 1)),
              
//             ],
//           ),
//           const SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               buildSocialButton('assets/google.png'),
//               const SizedBox(width: 20),
//               buildSocialButton('assets/apple.png'),
//             ],
//           ),
              
//         ],
//       ),
//     );
//   }
  
// }
// class SignUpForm extends StatefulWidget {
//   final bool isVisible;
//   final VoidCallback onLoginPressed;

//   const SignUpForm({
//     super.key,
//     required this.isVisible,
//     required this.onLoginPressed,
//   });

//   @override
//   SignUpFormState createState() => SignUpFormState();
// }

// class SignUpFormState extends State<SignUpForm> {
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;
//   final _formKey = GlobalKey<FormState>();

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(24.0),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Create Account',
//               style: TextStyle(
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFFEEF2F7),
//               ),
//             ),
//             const SizedBox(height: 30),

//             buildInputField(
//               controller: _nameController,
//               hintText: 'Full Name',
//               prefixIcon: Icons.person_outlined,
//               validator: (value) =>
//                   value == null || value.isEmpty ? 'Please enter your name' : null,
//             ),

//             const SizedBox(height: 16),

//             buildInputField(
//               controller: _emailController,
//               hintText: 'Email',
//               prefixIcon: Icons.email_outlined,
//               validator: (value) {
//                 if (value == null || value.isEmpty) return 'Please enter your email';
//                 if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
//                     .hasMatch(value)) {
//                   return 'Please enter a valid email';
//                 }
//                 return null;
//               },
//             ),

//             const SizedBox(height: 16),

//             buildInputField(
//               controller: _passwordController,
//               hintText: 'Password',
//               prefixIcon: Icons.lock_outlined,
//               obscureText: _obscurePassword,
//               validator: (value) {
//                 if (value == null || value.isEmpty) return 'Please enter a password';
//                 if (value.length < 6) return 'Password should be at least 6 characters';
//                 return null;
//               },
//               suffixIcon: IconButton(
//                 icon: Icon(
//                   _obscurePassword ? Icons.visibility_off : Icons.visibility,
//                   color: Color(0xFFE0E6FF),
//                 ),
//                 onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
//               ),
//             ),

//             const SizedBox(height: 16),

//             buildInputField(
//               controller: _confirmPasswordController,
//               hintText: 'Confirm Password',
//               prefixIcon: Icons.lock_outlined,
//               obscureText: _obscureConfirmPassword,
//               validator: (value) {
//                 if (value == null || value.isEmpty) return 'Please confirm your password';
//                 if (value != _passwordController.text) return 'Passwords do not match';
//                 return null;
//               },
//               suffixIcon: IconButton(
//                 icon: Icon(
//                   _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
//                   color: Color(0xFFE0E6FF),
//                 ),
//                 onPressed: () =>
//                     setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
//               ),
//             ),
//             const SizedBox(height: 24),

//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: () async {
//                   if (_formKey.currentState!.validate()) {
//                     final authProvider = Provider.of<AuthProvider>(context, listen: false);

//                     final success = await authProvider.register(
//                       name: _nameController.text,
//                       email: _emailController.text,
//                       password: _passwordController.text,
//                     );

//                     if (success) {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ChangeNotifierProvider<AuthProvider>.value(
//                             value: Provider.of<AuthProvider>(context, listen: false),
//                             child: const ChatScreen(),
//                           ),
//                         ),
//                       );
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text(authProvider.errorMessage ?? 'Registration failed')),
//                       );
//                     }
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF0077B6),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//                 ),
//                 child: const Text(
//                   'SIGN UP',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 25),

//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text('Already have an account? ', style: TextStyle(color: Color(0xFFEEF2F7))),
//                 GestureDetector(
//                   onTap: widget.onLoginPressed,
//                   child: Text('Login',
//                       style: TextStyle(color: Color(0xFF4A90E2), fontWeight: FontWeight.bold)),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 30),

//             Row(
//               children: [
//                 Expanded(child: Divider(color: Color.fromARGB(255, 95, 93, 255), thickness: 1)),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 8),
//                   child: Text('Or Sign Up With',
//                       style: TextStyle(color: Color(0xFFEEF2F7), fontSize: 14)),
//                 ),
//                 Expanded(child: Divider(color: Color.fromARGB(255, 95, 93, 255), thickness: 1)),
//               ],
//             ),

//             const SizedBox(height: 20),

//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 buildSocialButton('assets/google.png'),
//                 const SizedBox(width: 20),
//                 buildSocialButton('assets/apple.png'),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Widget buildTextFormField({
// //     required TextEditingController controller,
// //     required String labelText,
// //     required IconData icon,
// //     bool obscureText = false,
// //     TextInputType keyboardType = TextInputType.text,
// //     Widget? suffixIcon,
// //     String? Function(String?)? validator,
// //   }) {
// //     return TextFormField(
// //       controller: controller,
// //       obscureText: obscureText,
// //       keyboardType: keyboardType,
// //       validator: validator,
// //       style: const TextStyle(fontSize: 16),
// //       decoration: InputDecoration(
// //         labelText: labelText,
// //         labelStyle: TextStyle(color: Color(0xFFE0E6FF)),
// //         floatingLabelBehavior: FloatingLabelBehavior.auto,
// //         floatingLabelStyle: TextStyle(color: Colors.blue[700], fontWeight: FontWeight.w500),
// //         prefixIcon: Icon(icon, color: Color(0xFFE0E6FF)),
// //         suffixIcon: suffixIcon,
// //         filled: true,
// //         fillColor: Color(0x40202442),
// //         border: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(8),
// //           borderSide: BorderSide.none,
// //         ),
// //         focusedBorder: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(8),
// //           borderSide: BorderSide(color: Colors.blue[700]!, width: 1.5),
// //         ),
// //         errorBorder: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(8),
// //           borderSide: BorderSide(color: Colors.red[400]!, width: 1.0),
// //         ),
// //         focusedErrorBorder: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(8),
// //           borderSide: BorderSide(color: Colors.blue[700]!, width: 1.5),
// //         ),
        
// //         contentPadding: const EdgeInsets.symmetric(vertical: 16),
// //       ),
// //     );
// // }
// Widget buildInputField({
//   required TextEditingController controller,
//   required String hintText,
//   required IconData prefixIcon,
//   bool obscureText = false,
//   Widget? suffixIcon,
//   String? Function(String?)? validator,
// }) {
//   return TextFormField(
//     controller: controller,
//     obscureText: obscureText,
//     validator: validator,
//     decoration: InputDecoration(
//       hintText: hintText,
//       prefixIcon: Icon(prefixIcon, color: Color(0xFF006D7E)),
//       filled: true,
//       fillColor: Colors.white,
//       contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(30),
//         borderSide: BorderSide.none,
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(30),
//         borderSide: const BorderSide(color: Color(0xFF006D7E), width: 1),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(30),
//         borderSide: const BorderSide(color: Colors.red, width: 1),
//       ),
//       focusedErrorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(30),
//         borderSide: const BorderSide(color: Colors.red, width: 1),
//       ),
//       suffixIcon: suffixIcon,
//     ),
//     style: const TextStyle(fontSize: 16, color: Colors.black87),
//   );
// }

// Widget buildSocialButton(String imagePath) {
//   return ElevatedButton(
//     onPressed: () {
//     },
//     style: ElevatedButton.styleFrom(
//       shape: const CircleBorder(),
//       backgroundColor: Colors.white,
//       padding: const EdgeInsets.all(12),
//       elevation: 4,
//       shadowColor: Colors.black.withOpacity(0.1),
//     ),
//     child: Image.asset(
//       imagePath,
//       width: 30,
//       height: 30,
//       fit: BoxFit.contain,
//     ),
//   );
// }