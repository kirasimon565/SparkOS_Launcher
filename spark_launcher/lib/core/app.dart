import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/settings_service.dart';
import 'routes.dart';

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
        fontFamily: 'SparkSans',
      ),
      initialRoute: initialRoute,
      routes: SparkRoutes.routes,
    );
  }
}
