import 'package:flutter/material.dart';
import 'login_form.dart';
import 'signup_form.dart';
import 'package:gemexplora/widgets/auth_header.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);
  @override
  AuthPageState createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage>
    with SingleTickerProviderStateMixin {
  bool _isLogin = true, _showTitle = false, _showSubtitle = false;
  late final AnimationController _animationController;
  late final Animation<Offset> _loginSlide, _signupSlide;
  late final Animation<double> _loginFade, _signupFade, _panelOffset;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500),
    );

    _loginSlide = Tween<Offset>(begin: Offset.zero, end: const Offset(-1.5, 0))
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _loginFade = Tween<double>(begin: 1, end: 0)
        .animate(CurvedAnimation(parent: _animationController, curve: const Interval(0, .5, curve: Curves.easeOut)));

    _signupSlide = Tween<Offset>(begin: const Offset(1.5, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _signupFade = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _animationController, curve: const Interval(.5, 1, curve: Curves.easeIn)));

    _panelOffset = Tween<double>(begin: .25, end: .15)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() => _showTitle = true);
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() => _showSubtitle = true);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggle() {
    if (_isLogin) _animationController.forward();
    else _animationController.reverse();
    setState(() => _isLogin = !_isLogin);
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          const Positioned(
            top: 0, left: 0,
            child: SizedBox(
              width: 120, height: 120,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(120)),
                ),
              ),
            ),
          ),

          AuthHeader(showTitle: _showTitle, showSubtitle: _showSubtitle),

          AnimatedBuilder(
            animation: _panelOffset,
            builder: (ctx, _) {
              final top = h * _panelOffset.value;
              return Positioned(
                top: top, left: 0, right: 0, bottom: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Stack(children: [
                      SlideTransition(
                        position: _loginSlide,
                        child: FadeTransition(
                          opacity: _loginFade,
                          child: LoginForm(isVisible: _isLogin, onSignUpPressed: _toggle),
                        ),
                      ),
                      SlideTransition(
                        position: _signupSlide,
                        child: FadeTransition(
                          opacity: _signupFade,
                          child: SignUpForm(isVisible: !_isLogin, onLoginPressed: _toggle),
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
