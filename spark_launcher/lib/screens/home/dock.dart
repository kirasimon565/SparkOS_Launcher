import 'package:flutter/material.dart';

class Dock extends StatelessWidget {
  const Dock({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(Icons.phone, color: Colors.white),
          Icon(Icons.message, color: Colors.white),
          Icon(Icons.apps, color: Colors.amber, size: 32),
          Icon(Icons.camera_alt, color: Colors.white),
          Icon(Icons.language, color: Colors.white),
        ],
      ),
    );
  }
}
