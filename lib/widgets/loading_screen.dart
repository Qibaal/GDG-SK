// lib/widgets/loading_screen.dart
import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late List<Animation<double>> _gemAnimations;

  final List<Color> _gemColors = [
    const Color(0xFFB5B8E8),
    const Color(0xFF7E6ED1),
    const Color(0xFF9DE4F3),
    const Color(0xFF00B2C2),
    const Color(0xFF00A0B4),
  ];

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..repeat();
    _scaleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..forward();

    _gemAnimations = List.generate(5, (index) {
      final startDelay = index * 0.15;
      final endTime = math.min(startDelay + 0.6, 1.0);
      return CurvedAnimation(
        parent: _scaleController,
        curve: Interval(startDelay, endTime, curve: Curves.easeOut),
      );
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Blur background
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
          child: Container(
            color: Colors.black.withOpacity(0.4), // dark overlay
          ),
        ),
        Center(
          child: SizedBox(
            height: 280,
            width: 280,
            child: AnimatedBuilder(
              animation: Listenable.merge([_rotationController, _scaleController]),
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: List.generate(5, (i) => _buildGem(i)),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGem(int index) {
    final angle = _rotationController.value * 2 * math.pi + (index * (2 * math.pi / 5)) - (math.pi / 2);
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
          shadowColor: _gemColors[index].withOpacity(0.5),
          size: size * 2.4,
        ),
      ),
    );
  }
}

class _KitePainter extends CustomPainter {
  final Color color;
  final Color shadowColor;
  final double size;

  _KitePainter({required this.color, required this.shadowColor, required this.size});

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    final shadowPaint = Paint()
      ..color = shadowColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final top = size * 0.4;
    final bottom = size * 0.6;
    final left = size * 0.3;
    final right = size * 0.3;

    final cx = canvasSize.width / 2;
    final cy = canvasSize.height / 2;

    final path = Path()
      ..moveTo(cx, cy - top)
      ..lineTo(cx + right, cy)
      ..lineTo(cx, cy + bottom)
      ..lineTo(cx - left, cy)
      ..close();

    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
