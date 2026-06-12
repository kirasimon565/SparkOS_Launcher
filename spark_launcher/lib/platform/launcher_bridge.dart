import 'package:flutter/services.dart';

class LauncherBridge {
  static const MethodChannel _channel = MethodChannel('spark_launcher/launcher_bridge');

  static Future<void> requestDefaultLauncher() async {
    try {
      await _channel.invokeMethod('requestDefaultLauncher');
    } on PlatformException {
      // ignore: avoid_print
      print("Failed to request default launcher.");
    }
  }

  static Future<bool> isDefaultLauncher() async {
    try {
      final bool result = await _channel.invokeMethod('isDefaultLauncher');
      return result;
    } on PlatformException {
      // ignore: avoid_print
      print("Failed to check default launcher.");
      return false;
    }
  }
}
