// lib/core/animations.dart

import 'package:flutter/material.dart';

class SparkAnimations {
  // Curves
  static const Curve defaultCurve = Curves.easeOut;
  static const Curve sparkExpandCurve = Curves.easeOutCubic;
  static const Curve drawerCurve = Curves.easeIn;
  static const Curve breatheCurve = Curves.easeInOut;

  // Durations
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration breathe = Duration(milliseconds: 3500);
  static const Duration particleBurst = Duration(milliseconds: 600);
  static const Duration dockExpand = Duration(milliseconds: 500);
  static const Duration searchFade = Duration(milliseconds: 200);
  static const Duration themeChange = Duration(milliseconds: 500);
  static const Duration eyeOpen = Duration(milliseconds: 500);
  static const Duration eyeClose = Duration(milliseconds: 400);
}

// Backward compatibility alias for home_screen.dart
class SparkAnimationDuration {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration breathe = Duration(milliseconds: 3500);
}
