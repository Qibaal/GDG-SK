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
  late List<Animation<double>> _diamondRotationAnimations;
  late List<Animation<double>> _diamondScaleAnimations;
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
    
    // Animation controller with longer duration for smoother animations
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    
    // Create position animations for each diamond with smoother curves
    _diamondAnimations = List.generate(5, (index) {
      final begin = 0.0;
      final end = 1.0;
      final delay = index * 0.15; // Slightly faster staggering
      
      return Tween<double>(begin: begin, end: end).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(delay, math.min(delay + 0.7, 1.0), curve: Curves.easeOutCirc),
        ),
      );
    });
    
    // Add rotation animations
    _diamondRotationAnimations = List.generate(5, (index) {
      final delay = index * 0.15;
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(delay, math.min(delay + 0.7, 1.0), curve: Curves.easeOutBack),
        ),
      );
    });
    
    // Add scale animations for breathing effect
    _diamondScaleAnimations = List.generate(5, (index) {
      final delay = index * 0.15;
      return Tween<double>(begin: 0.7, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(delay, math.min(delay + 0.6, 1.0), curve: Curves.easeOutCirc),
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
      Future.delayed(widget.duration - const Duration(milliseconds: 2500), () {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => widget.nextScreen,
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800), // Longer transition
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
                height: 220,
                width: 220,
                child: Stack(
                  alignment: Alignment.center,
                  children: List.generate(5, (index) {
                    return AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        // Calculate path using simpler movement for better reliability
                        final pathProgress = _diamondAnimations[index].value;
                        final double radius = 50.0;
                        final angle = (index * math.pi / 2.5);
                        
                        // Simple circular motion
                        final bezierX = math.sin(angle) * radius * pathProgress;
                        final bezierY = math.cos(angle) * radius * pathProgress;
                        
                        // Add a more subtle wobble effect
                        final wobble = math.sin(pathProgress * math.pi) * 3 * (1 - pathProgress);
                        
                        // Calculate rotation
                        final baseRotation = (index * math.pi / 5);
                        final additionalRotation = _diamondRotationAnimations[index].value * math.pi / 4;
                        final scale = _diamondScaleAnimations[index].value;
                        
                        return Transform.translate(
                          offset: Offset(
                            bezierX + wobble * math.cos(angle),
                            bezierY + wobble * math.sin(angle),
                          ),
                          child: Transform.rotate(
                            angle: baseRotation + additionalRotation,
                            child: Transform.scale(
                              scale: scale,
                              child: Opacity(
                                opacity: _diamondAnimations[index].value,
                                child: Diamond(
                                  size: 60 + (index % 3) * 5,
                                  color: _diamondColors[index],
                                ),
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
              // Improved GemExplora text animation
              _buildGemExploraText(),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildGemExploraText() {
    final text = "GemExplora";
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(text.length, (index) {
            // Create staggered animations for each letter with bounce effect
            final startDelay = 0.3; // Start text animation after diamonds begin
            final letterDuration = 0.4; // Duration for each letter animation
            final letterDelay = 0.05; // Delay between letters
            
            // Ensure start and end values are properly clamped
            final start = (startDelay + (index * letterDelay)).clamp(0.0, 0.8);
            final end = math.min(start + letterDuration, 1.0);
            
            final opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
              CurvedAnimation(
                parent: _controller,
                curve: Interval(
                  start,
                  math.min(start + 0.2, 1.0),
                  curve: Curves.easeIn,
                ),
              ),
            );
            
            final slideAnimation = Tween<double>(begin: 20, end: 0).animate(
              CurvedAnimation(
                parent: _controller,
                curve: Interval(
                  start, 
                  end,
                  curve: Curves.easeOutBack, // Changed from elasticOut to easeOutBack
                ),
              ),
            );
            
            final scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
              CurvedAnimation(
                parent: _controller,
                curve: Interval(
                  start,
                  end,
                  curve: Curves.easeOutBack, // Changed from elasticOut to easeOutBack
                ),
              ),
            );
            
            // Add color transition for text
            final colorAnimation = ColorTween(
              begin: const Color(0xFF1A6DE3),
              end: const Color(0xFF2C7BEE),
            ).animate(
              CurvedAnimation(
                parent: _controller,
                curve: Interval(
                  start,
                  end,
                  curve: Curves.easeOut,
                ),
              ),
            );

            return Transform.translate(
              offset: Offset(0, slideAnimation.value),
              child: Transform.scale(
                scale: scaleAnimation.value,
                child: FadeTransition(
                  opacity: opacityAnimation,
                  child: Text(
                    text[index],
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: colorAnimation.value ?? const Color(0xFF2C7BEE),
                      shadows: [
                        Shadow(
                          blurRadius: 2.0,
                          color: Colors.black.withOpacity(0.1),
                          offset: const Offset(1.0, 1.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
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
          borderRadius: BorderRadius.circular(size * 0.2), // Slightly rounder corners
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.9),
              color,
              color.withOpacity(0.8),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 3),
            ),
          ],
        ),
      ),
    );
  }
}