import 'package:flutter/material.dart';
import '../screens/intro/intro_video_screen.dart';
import '../screens/intro/welcome_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/drawer/app_drawer.dart';
import '../screens/folders/folder_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/settings/about_screen.dart';
import '../screens/settings/appearance_screen.dart';
import '../screens/settings/themes_screen.dart';
import '../screens/settings/wallpaper_screen.dart';
import '../screens/settings/gestures_screen.dart';
import '../screens/settings/backup_screen.dart';

class SparkRoutes {
  static Map<String, WidgetBuilder> get routes => {
    '/intro': (context) => const IntroVideoScreen(),
    '/welcome': (context) => const WelcomeScreen(),
    '/home': (context) => const HomeScreen(),
    '/drawer': (context) => const AppDrawerScreen(),
    '/folder': (context) => const FolderScreen(),
    '/settings': (context) => const SettingsScreen(),
    '/settings/about': (context) => const AboutScreen(),
    '/settings/appearance': (context) => const AppearanceScreen(),
    '/settings/themes': (context) => const ThemesScreen(),
    '/settings/wallpaper': (context) => const WallpaperScreen(),
    '/settings/gestures': (context) => const GesturesScreen(),
    '/settings/backup': (context) => const BackupScreen(),
  };
}
