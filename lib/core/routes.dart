import 'package:flutter/material.dart';
import '../screens/intro/intro_video_screen.dart';
import '../screens/intro/welcome_screen.dart';
import '../screens/home/home_screen.dart';

class SparkRoutes {
  static Map<String, WidgetBuilder> get routes => {
    '/intro': (context) => BirthOfStar(
      onComplete: () => Navigator.pushReplacementNamed(context, '/welcome'),
    ),
    '/welcome': (context) => const WelcomeScreen(),
    '/home': (context) => const HomeScreen(),
  };
}
