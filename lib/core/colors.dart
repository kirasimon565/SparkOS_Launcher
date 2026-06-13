// lib/core/colors.dart

import 'package:flutter/material.dart';

class SparkColors {
  // Primary palette
  static const Color amber = Color(0xFFE6A800);
  static const Color amberLight = Color(0xFFF0D080);
  static const Color amberWhite = Color(0xFFF5E6C8);
  static const Color amberGlow = Color(0xFFFFD54F);

  // Neutrals
  static const Color black = Colors.black;
  static const Color darkGray = Color(0xFF1A1A1A);
  static const Color mediumGray = Color(0xFF2A2A2A);
  static const Color lightGray = Color(0xFF888888);
  static const Color coldWhite = Color(0xFFE0E0E0);
  static const Color white = Colors.white;

  // Theme-specific
  static const Color deepBlue = Color(0xFF0A1628);
  static const Color deepPurple = Color(0xFF1A0A2E);
  static const Color cyan = Color(0xFF00BCD4);

  // Semantic
  static const Color sparkCore = amber;
  static const Color sparkGlow = amberLight;
  static const Color background = black;
  static const Color surface = darkGray;
  static const Color textPrimary = white;
  static const Color textSecondary = lightGray;
  static const Color divider = mediumGray;
}
