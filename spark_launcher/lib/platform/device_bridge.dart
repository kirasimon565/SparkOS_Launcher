import 'package:flutter/services.dart';

class DeviceBridge {
  static const MethodChannel _channel = MethodChannel('spark_launcher/device_bridge');

  static Future<void> lockScreen() async {
    try {
      await _channel.invokeMethod('lockScreen');
    } on PlatformException {
      // ignore: avoid_print
      print("Failed to lock screen.");
    }
  }
}
