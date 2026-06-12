import 'package:flutter/material.dart';
import '../screens/intro/intro_video_screen.dart';
import '../screens/intro/welcome_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/drawer/app_drawer.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/settings/appearance_screen.dart';
import '../screens/settings/themes_screen.dart';
import '../screens/settings/wallpaper_screen.dart';
import '../screens/settings/gestures_screen.dart';
import '../screens/settings/backup_screen.dart';
import '../screens/settings/about_screen.dart';
import '../widgets/spark_transition.dart';

class SparkRoutes {
  static const String intro = '/intro';
  static const String welcome = '/welcome';
  static const String home = '/home';
  static const String drawer = '/drawer';
  static const String settings = '/settings';
  static const String appearanceSettings = '/settings/appearance';
  static const String themesSettings = '/settings/themes';
  static const String wallpaperSettings = '/settings/wallpaper';
  static const String gestureSettings = '/settings/gestures';
  static const String backupSettings = '/settings/backup';
  static const String aboutSettings = '/settings/about';

  static Map<String, WidgetBuilder> get routes => {
        intro: (context) => const IntroVideoScreen(),
        welcome: (context) => const WelcomeScreen(),
        home: (context) => const HomeScreen(),
        drawer: (context) => const AppDrawer(apps: []),
        settings: (context) => const SettingsScreen(),
        appearanceSettings: (context) => const AppearanceScreen(),
        themesSettings: (context) => const ThemesScreen(),
        wallpaperSettings: (context) => const WallpaperScreen(),
        gestureSettings: (context) => const GesturesScreen(),
        backupSettings: (context) => const BackupScreen(),
        aboutSettings: (context) => const AboutScreen(),
      };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case intro:
        return SparkPageRoute(page: const IntroVideoScreen());
      case welcome:
        return SparkPageRoute(page: const WelcomeScreen());
      case home:
        return SparkPageRoute(page: const HomeScreen());
      case drawer:
        return SparkPageRoute(page: const AppDrawer(apps: []));
      case SparkRoutes.settings:
        return SparkPageRoute(page: const SettingsScreen());
      case appearanceSettings:
        return SparkPageRoute(page: const AppearanceScreen());
      case themesSettings:
        return SparkPageRoute(page: const ThemesScreen());
      case wallpaperSettings:
        return SparkPageRoute(page: const WallpaperScreen());
      case gestureSettings:
        return SparkPageRoute(page: const GesturesScreen());
      case backupSettings:
        return SparkPageRoute(page: const BackupScreen());
      case aboutSettings:
        return SparkPageRoute(page: const AboutScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(body: Center(child: Text('Not Found'))),
        );
    }
  }
}
