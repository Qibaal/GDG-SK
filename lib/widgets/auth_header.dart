import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  final bool showTitle, showSubtitle;
  const AuthHeader({super.key, required this.showTitle, required this.showSubtitle});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      // the curved corner
      Positioned(
        top: 0, left: 0,
        child: Container(
          width: 120, height: 120,
          decoration: const BoxDecoration(
            color: Color(0xFFF5F5F5),
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(120)),
          ),
        ),
      ),
      // Hello! + subtitle
      Positioned(
        top: 200, left: 20,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: showTitle ? 1 : 0,
            child: const Text('Hello!', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF0077B6))),
          ),
          const SizedBox(height: 8),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: showSubtitle ? 1 : 0,
            child: const Text('Welcome to GemExplora', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xFF0077B6))),
          ),
        ]),
      ),
    ]);
  }
}
