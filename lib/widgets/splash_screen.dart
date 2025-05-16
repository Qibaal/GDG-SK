import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final Widget nextScreen;
  final Duration duration;

  const SplashScreen({
    Key? key,
    required this.nextScreen,
    this.duration = const Duration(seconds: 3),
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  bool _fadeOut = false;
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late AnimationController _textController;
  
  late List<Animation<double>> _gemAnimations;
  
  final List<Color> _gemColors = [
    const Color(0xFFB5B8E8), 
    const Color(0xFF7E6ED1), 
    const Color(0xFF9DE4F3), 
    const Color(0xFF00B2C2), 
    const Color(0xFF00A0B4), 
  ];
  
  final Duration _rotationDuration = const Duration(milliseconds: 5000);
  final Duration _scaleDuration = const Duration(milliseconds: 2500);
  final Duration _textDuration = const Duration(milliseconds: 1500);
  
  @override
  void initState() {
    super.initState();
    
    _rotationController = AnimationController(
      duration: _rotationDuration,
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: _scaleDuration,
      vsync: this,
    );
    
    _textController = AnimationController(
      duration: _textDuration,
      vsync: this,
    );
    
    _gemAnimations = List.generate(5, (index) {
      final startDelay = index * 0.15; 
      final endTime = math.min(startDelay + 0.6, 1.0);
      return CurvedAnimation(
        parent: _scaleController,
        curve: Interval(
          startDelay, 
          endTime, 
          curve: Curves.easeOut,
        ),
      );
    });
    
    _startAnimationSequence();
  }
  
  void _startAnimationSequence() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _rotationController.forward();
    _scaleController.forward();

    await Future.delayed(const Duration(milliseconds: 2500));
    _textController.forward();

    await Future.delayed(widget.duration);

    if (!mounted) return;
    setState(() => _fadeOut = true);
  }
  
  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  Widget _buildGemExploraText() {
    final text = "GemExplora";

    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(text.length, (index) {
            final startDelay = 0.3;
            final letterDuration = 0.4;
            final letterDelay = 0.05;

            final start = (startDelay + (index * letterDelay)).clamp(0.0, 0.8);
            final end = math.min(start + letterDuration, 1.0);

            final opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
              CurvedAnimation(
                parent: _textController,
                curve: Interval(
                  start,
                  math.min(start + 0.2, 1.0),
                  curve: Curves.easeIn,
                ),
              ),
            );

            final slideAnimation = Tween<double>(begin: 20, end: 0).animate(
              CurvedAnimation(
                parent: _textController,
                curve: Interval(
                  start,
                  end,
                  curve: Curves.easeOutBack,
                ),
              ),
            );

            final scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
              CurvedAnimation(
                parent: _textController,
                curve: Interval(
                  start,
                  end,
                  curve: Curves.easeOutBack,
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
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: index < 3
                      ? const Color(0xFF735CA4)
                      : const Color(0xFF3793DA), 
                      shadows: [
                        Shadow(
                          blurRadius: 2.0,
                          color: Colors.black.withAlpha((0.1 * 255).toInt()),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 24, 24, 136), 
      body: AnimatedOpacity(
        opacity: _fadeOut ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 800),
        onEnd: () {
          if (_fadeOut) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => widget.nextScreen),
            );
          }
        },
        child: Container(
          color: const Color.fromARGB(255, 24, 24, 136), 
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 280,
                  width: 280,
                  child: AnimatedBuilder(
                    animation: Listenable.merge([_rotationController, _scaleController]),
                    builder: (context, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          for (int i = 0; i < 5; i++) _buildGem(i),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 60),
                _buildGemExploraText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGem(int index) {
    final angle = _rotationController.value * 2 * math.pi + 
                  (index * (2 * math.pi / 5)) - (math.pi / 2);
    final radius = 120.0;
    
    final x = math.cos(angle) * radius;
    final y = math.sin(angle) * radius;
    
    final size = 70.0 * _gemAnimations[index].value;
    
    final rotation = angle + math.pi / 4; 
    
    return Transform.translate(
      offset: Offset(x, y),
      child: Transform.rotate(
        angle: rotation,
        child: Transform.scale(
          scale: _gemAnimations[index].value,
          child: _buildGemShape(index, size),
        ),
      ),
    );
  }

  Widget _buildGemShape(int index, double size) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _KitePainter(
          color: _gemColors[index],
          shadowColor: _gemColors[index],
          size: size*2.4,
        ),
      ),
    );
  }

}

class _KitePainter extends CustomPainter {
  final Color color;
  final Color shadowColor;
  final double size;

  _KitePainter({
    required this.color,
    required this.shadowColor,
    required this.size,
  });

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = shadowColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final double topLength = size * 0.4;
    final double bottomLength = size * 0.6;
    final double leftLength = size * 0.3;
    final double rightLength = size * 0.3;

    final centerX = canvasSize.width / 2;
    final centerY = canvasSize.height / 2;

    final path = Path()
      ..moveTo(centerX, centerY - topLength) 
      ..lineTo(centerX + rightLength, centerY) 
      ..lineTo(centerX, centerY + bottomLength) 
      ..lineTo(centerX - leftLength, centerY) 
      ..close();

    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, paint);

    final highlight = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawPath(path, highlight);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GemShinePainter extends CustomPainter {
  final Color gemColor;
  
  GemShinePainter(this.gemColor);
  
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    final path = Path()
      ..moveTo(size.width * 0.2, size.height * 0.2)
      ..lineTo(size.width * 0.5, size.height * 0.3)
      ..lineTo(size.width * 0.3, size.height * 0.5)
      ..close();
      
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Splash effects for a more futuristic feel
class ParticleEffect extends StatelessWidget {
  final Animation<double> animation;
  final Offset position;
  final Color color;
  
  const ParticleEffect({
    Key? key,
    required this.animation,
    required this.position,
    required this.color,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Opacity(
            opacity: 1.0 - animation.value,
            child: Transform.scale(
              scale: animation.value * 2.0,
              child: Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
