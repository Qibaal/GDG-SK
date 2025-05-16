import 'dart:async';
import 'package:flutter/material.dart';
import 'login_form.dart';
import 'signup_form.dart';

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
    
    // Initialize animations
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
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
                    child: const Text(
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
                    child: const Text(
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