import 'package:flutter/material.dart';

class ThemeModel {
  final String name;
  final Color primaryColor;
  final Color accentColor;
  final Color backgroundColor;
  final Color textColor;

  const ThemeModel({
    required this.name,
    required this.primaryColor,
    required this.accentColor,
    required this.backgroundColor,
    required this.textColor,
  });
}
