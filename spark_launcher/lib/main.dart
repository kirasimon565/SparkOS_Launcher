import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/settings_provider.dart';
import 'screens/intro/intro_video_screen.dart';
import 'screens/intro/welcome_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/drawer/app_drawer.dart';
import 'screens/folders/folder_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/settings/about_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const SparkLauncherApp(),
    ),
  );
}

class SparkLauncherApp extends ConsumerWidget {
  const SparkLauncherApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final initialRoute = settings.hasSeenIntro ? '/home' : '/intro';

    return MaterialApp(
      title: 'Spark Launcher',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
      ),
      initialRoute: initialRoute,
      routes: {
        '/intro': (context) => const IntroVideoScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/home': (context) => const HomeScreen(),
        '/drawer': (context) => const AppDrawerScreen(),
        '/folder': (context) => const FolderScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/settings/about': (context) => const AboutScreen(),
        // Add additional settings routes here as needed
      },
    );
  }
}
