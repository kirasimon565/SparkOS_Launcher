import 'package:flutter/services.dart';

class PackageManager {
  static const MethodChannel _channel = MethodChannel('spark_launcher/package_manager');

  static Future<void> launchApp(String packageName) async {
    try {
      await _channel.invokeMethod('launchApp', {'packageName': packageName});
    } on PlatformException {
      // ignore: avoid_print
      print("Failed to launch app.");
    }
  }
}
