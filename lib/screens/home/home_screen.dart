import 'package:flutter/material.dart';
import '../../widgets/spark_star.dart';
import '../../widgets/orbital_ring.dart';
import '../../widgets/spark_gestures.dart';
import '../../widgets/spark_wallpaper.dart';
import '../../models/app_model.dart';
import '../../core/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  EyeState _eyeState = EyeState.resting;
  bool _menuVisible = false;
  
  // Sample apps for the orbital ring
  final List<OrbitalApp> _apps = [
    const OrbitalApp(packageName: 'phone', appName: 'Phone', icon: Icons.phone, isFavorite: true, orbitalDistance: 0.9),
    const OrbitalApp(packageName: 'messages', appName: 'Messages', icon: Icons.message, orbitalDistance: 1.1),
    const OrbitalApp(packageName: 'camera', appName: 'Camera', icon: Icons.camera_alt, isFavorite: true, orbitalDistance: 0.85),
    const OrbitalApp(packageName: 'chrome', appName: 'Chrome', icon: Icons.language, orbitalDistance: 1.05),
    const OrbitalApp(packageName: 'gallery', appName: 'Gallery', icon: Icons.photo_library, orbitalDistance: 1.15),
    const OrbitalApp(packageName: 'music', appName: 'Music', icon: Icons.music_note, orbitalDistance: 0.95),
    const OrbitalApp(packageName: 'settings', appName: 'Settings', icon: Icons.settings, isFavorite: true, orbitalDistance: 1.0),
    const OrbitalApp(packageName: 'maps', appName: 'Maps', icon: Icons.map, orbitalDistance: 1.2),
  ];

  void _handleGesture(SparkGesture gesture) {
    setState(() {
      switch (gesture) {
        case SparkGesture.tap:
          // Open app drawer
          break;
        case SparkGesture.doubleTap:
          // Open recent app
          break;
        case SparkGesture.longPress:
          _menuVisible = !_menuVisible;
          break;
        case SparkGesture.dragUp:
          // Open drawer
          break;
        case SparkGesture.dragDown:
          // Open notifications
          break;
        case SparkGesture.dragLeft:
          // Previous constellation
          break;
        case SparkGesture.dragRight:
          // Next constellation
          break;
        case SparkGesture.pinch:
          // Overview mode
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SparkWallpaper(
        type: WallpaperType.nebula,
        child: SparkGestureDetector(
          onGesture: _handleGesture,
          child: Stack(
            children: [
              // The Spark Star - center
              Center(
                child: SparkStar(
                  size: 48,
                  eyeState: _eyeState,
                  onTap: () => _handleGesture(SparkGesture.tap),
                  onDoubleTap: () => _handleGesture(SparkGesture.doubleTap),
                  onLongPress: () => _handleGesture(SparkGesture.longPress),
                ),
              ),
              
              // The Orbital Ring
              Center(
                child: OrbitalRing(
                  apps: _apps,
                  starSize: 48,
                  onAppSelected: (app) {
                    // Launch app
                  },
                ),
              ),
              
              // Status bar hint
              Positioned(
                top: 60,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    _getTimeContext(),
                    style: TextStyle(
                      color: SparkColors.amber.withOpacity(0.3),
                      fontSize: 11,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTimeContext() {
    final hour = DateTime.now().hour;
    if (hour >= 6 && hour < 9) return 'the spark awakens';
    if (hour >= 9 && hour < 18) return 'the spark watches';
    if (hour >= 18 && hour < 22) return 'the spark dims';
    return 'the spark rests';
  }
}
