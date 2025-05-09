import 'package:flutter/material.dart';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  final Widget nextScreen;
  final Duration duration;

  const SplashScreen({
    super.key,
    required this.nextScreen,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _diamondAnimations;
  late Animation<double> _fadeAnimation;
  
  final List<Color> _diamondColors = [
    const Color(0xFFD1C3CF), // Light purple/gray
    const Color(0xFFD3C0B7), // Beige/tan
    const Color(0xFFCCD2F0), // Light blue/lavender
    const Color(0xFF2C7BEE), // Bright blue
    const Color(0xFF1A6DE3), // Deeper blue
  ];

  @override
  void initState() {
    super.initState();
    
    // Animation controller for the entire splash screen
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    
    // Create animations for each diamond with different delays
    _diamondAnimations = List.generate(5, (index) {
      final begin = 0.0;
      final end = 1.0;
      final delay = index * 0.2; // Stagger the animations
      
      return Tween<double>(begin: begin, end: end).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(delay, delay + 0.6, curve: Curves.easeOut),
        ),
      );
    });
    
    // Fade animation for the entire screen
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
    
    // Start the animation and navigate after it completes
    _controller.forward().then((_) {
      Future.delayed(widget.duration - const Duration(milliseconds: 2000), () {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => widget.nextScreen,
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                width: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: List.generate(5, (index) {
                    return AnimatedBuilder(
                      animation: _diamondAnimations[index],
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(
                            math.sin(index * math.pi / 2.5) * 40 * _diamondAnimations[index].value,
                            math.cos(index * math.pi / 2.5) * 40 * _diamondAnimations[index].value,
                          ),
                          child: Transform.rotate(
                            angle: (index * math.pi / 5) + (_diamondAnimations[index].value * math.pi / 8),
                            child: Opacity(
                              opacity: _diamondAnimations[index].value,
                              child: Diamond(
                                size: 60 + (index % 3) * 5,
                                color: _diamondColors[index],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
              const SizedBox(height: 40),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _controller.value,
                    child: const Text(
                      "GemExplora",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C7BEE),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Diamond extends StatelessWidget {
  final double size;
  final Color color;

  const Diamond({
    super.key,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: math.pi / 4, // 45 degrees in radians
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(size * 0.15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }
}