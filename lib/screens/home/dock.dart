import 'package:flutter/material.dart';
import 'dart:ui';

class SparkDock extends StatelessWidget {
  const SparkDock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 80,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.phone, color: Colors.white),
              Icon(Icons.message, color: Colors.white),
              Icon(Icons.camera, color: Colors.white),
              Icon(Icons.settings, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
