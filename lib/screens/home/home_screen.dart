import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/spark_star.dart';
import '../../widgets/orbital_ring.dart';
import '../../widgets/spark_gestures.dart';
import '../../widgets/spark_wallpaper.dart';
import '../../services/apps_service.dart';
import '../../models/app_model.dart';
import '../../core/colors.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  EyeState _eyeState = EyeState.resting;
  bool _menuVisible = false;

  void _handleGesture(SparkGesture gesture) {
    setState(() {
      switch (gesture) {
        case SparkGesture.tap: break;
        case SparkGesture.doubleTap: break;
        case SparkGesture.longPress: _menuVisible = !_menuVisible; break;
        case SparkGesture.dragUp: break;
        case SparkGesture.dragDown: break;
        case SparkGesture.dragLeft: break;
        case SparkGesture.dragRight: break;
        case SparkGesture.pinch: break;
      }
    });
  }

  String _getTimeContext() {
    final hour = DateTime.now().hour;
    if (hour >= 6 && hour < 9) return 'the spark awakens';
    if (hour >= 9 && hour < 18) return 'the spark watches';
    if (hour >= 18 && hour < 22) return 'the spark dims';
    return 'the spark rests';
  }

  @override
  Widget build(BuildContext context) {
    final appsAsync = ref.watch(appsProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SparkWallpaper(
        type: WallpaperType.nebula,
        child: SparkGestureDetector(
          onGesture: _handleGesture,
          child: Stack(
            children: [
              Center(
                child: SparkStar(
                  size: 48,
                  eyeState: _eyeState,
                  onTap: () => _handleGesture(SparkGesture.tap),
                  onDoubleTap: () => _handleGesture(SparkGesture.doubleTap),
                  onLongPress: () => _handleGesture(SparkGesture.longPress),
                ),
              ),
              Center(
                child: appsAsync.when(
                  data: (apps) => OrbitalRing(
                    apps: apps,
                    starSize: 48,
                    onAppSelected: (app) {
                      // Launch app via platform channel
                    },
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ),
              Positioned(
                top: 60, left: 0, right: 0,
                child: Center(
                  child: Text(
                    _getTimeContext(),
                    style: TextStyle(color: SparkColors.amber.withOpacity(0.3), fontSize: 11, letterSpacing: 2.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
