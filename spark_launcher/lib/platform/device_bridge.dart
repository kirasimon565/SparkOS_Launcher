import 'package:flutter/services.dart';

class DeviceBridge {
  static const MethodChannel _channel = MethodChannel('com.sparkos.launcher/device');

  static Future<String> getDeviceProfileLevel() async {
    try {
      final String profile = await _channel.invokeMethod('getDeviceProfileLevel');
      return profile;
    } on PlatformException catch (e) {
      print("Failed to get device profile: \${e.message}");
      return 'LEVEL_STANDARD'; // Default fallback
    }
  }
}
