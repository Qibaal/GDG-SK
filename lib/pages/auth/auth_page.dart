import 'package:flutter/material.dart';
import 'package:gemexplora/pages/auth/login_form.dart';
import 'package:gemexplora/pages/auth/signup_form.dart';
import 'package:gemexplora/widgets/auth_header.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});
  @override
  AuthPageState createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage>
    with SingleTickerProviderStateMixin {
  bool _isLogin = true, _showTitle = false, _showSubtitle = false;
  late final AnimationController _animationController;
  late final Animation<Offset> _loginSlideAnimation, _signUpSlideAnimation;
  late final Animation<double> _loginOpacityAnimation, _signUpOpacityAnimation;
  late final Animation<double> _containerPositionAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500),
    );
    _loginSlideAnimation = Tween<Offset>(begin: Offset.zero, end: const Offset(-1.5, 0))
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _loginOpacityAnimation = Tween<double>(begin: 1, end: 0)
        .animate(CurvedAnimation(parent: _animationController, curve: const Interval(0, .5, curve: Curves.easeOut)));
    _signUpSlideAnimation = Tween<Offset>(begin: const Offset(1.5, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _signUpOpacityAnimation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _animationController, curve: const Interval(.5, 1, curve: Curves.easeIn)));
    _containerPositionAnimation = Tween<double>(begin: .25, end: .15)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    Future.delayed(const Duration(milliseconds: 500), () => setState(() => _showTitle = true));
    Future.delayed(const Duration(milliseconds: 1200), () => setState(() => _showSubtitle = true));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleForm() {
    if (_isLogin) _animationController.forward();
    else _animationController.reverse();
    setState(() => _isLogin = !_isLogin);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          // the curved header + hello text
          AuthHeader(showTitle: _showTitle, showSubtitle: _showSubtitle),

          // sliding panel
          AnimatedBuilder(
            animation: _containerPositionAnimation,
            builder: (ctx, _) {
              final top = height * _containerPositionAnimation.value;
              return Positioned(
                top: top, left: 0, right: 0, bottom: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: Stack(children: [
                      SlideTransition(
                        position: _loginSlideAnimation,
                        child: FadeTransition(
                          opacity: _loginOpacityAnimation,
                          child: LoginForm(isVisible: _isLogin, onSignUpPressed: _toggleForm),
                        ),
                      ),
                      SlideTransition(
                        position: _signUpSlideAnimation,
                        child: FadeTransition(
                          opacity: _signUpOpacityAnimation,
                          child: SignUpForm(isVisible: !_isLogin, onLoginPressed: _toggleForm),
                        ),
                      ),
                    ]),
                  ),
                ),
              );
            },
          ),
        ]),
      ),
    );
  }
}
