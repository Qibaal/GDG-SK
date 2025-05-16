import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final String assetPath;
  const SocialButton(this.assetPath, {super.key});

  @override
  Widget build(BuildContext c) => ElevatedButton(
    onPressed: () {/*…*/},
    style: ElevatedButton.styleFrom(
      shape: const CircleBorder(),
      backgroundColor: Colors.white,
      padding: const EdgeInsets.all(12),
      elevation: 4,
      shadowColor: Colors.black,
    ),
    child: Image.asset(assetPath, width: 30, height: 30, fit: BoxFit.contain),
  );
}
