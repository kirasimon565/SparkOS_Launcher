// lib/core/constants.dart

class AppConstants {
  // Animation durations (in milliseconds, for backward compatibility)
  static const int durationFast = 150;
  static const int durationMedium = 300;
  static const int durationSlow = 500;

  // Dock
  static const double dockIconSpacing = 64.0;
  static const double dockSparkSize = 56.0;
  static const double dockIconSize = 48.0;
  static const int dockMaxApps = 5;

  // Home screen
  static const int defaultGridColumns = 4;
  static const int defaultGridRows = 6;
  static const double pageIndicatorDotSize = 6.0;

  // Spark
  static const double sparkBreathScaleMin = 1.0;
  static const double sparkBreathScaleMax = 1.1;
  static const double sparkPressScale = 0.9;
  static const int sparkParticleCount = 5;
  static const int sparkPoints = 4;

  // App
  static const String appName = 'Spark Launcher';
  static const String appVersion = '2.0.0';
  static const String appPackage = 'com.sparkos.launcher';
}
