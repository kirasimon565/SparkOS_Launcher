import 'package:flutter/material.dart';
import '../models/theme_model.dart';

class SparkThemes {
  static const ember = ThemeModel(
    name: 'ember',
    primaryColor: Colors.black,
    accentColor: Colors.amber,
    backgroundColor: Color(0xFF0F0F0F),
    textColor: Colors.white,
  );

  static const ash = ThemeModel(
    name: 'ash',
    primaryColor: Colors.black,
    accentColor: Colors.grey,
    backgroundColor: Color(0xFF1A1A1A),
    textColor: Colors.white,
  );

  static const eclipse = ThemeModel(
    name: 'eclipse',
    primaryColor: Color(0xFF05051A),
    accentColor: Colors.lightBlueAccent,
    backgroundColor: Color(0xFF02020A),
    textColor: Colors.white,
  );

  static const aurora = ThemeModel(
    name: 'aurora',
    primaryColor: Color(0xFF1A052E),
    accentColor: Colors.cyanAccent,
    backgroundColor: Color(0xFF0D021A),
    textColor: Colors.white,
  );

  static ThemeModel getThemeByName(String name) {
    switch (name) {
      case 'ash':
        return ash;
      case 'eclipse':
        return eclipse;
      case 'aurora':
        return aurora;
      case 'ember':
      default:
        return ember;
    }
  }
}
