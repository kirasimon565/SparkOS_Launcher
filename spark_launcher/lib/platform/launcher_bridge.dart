import 'package:flutter/services.dart';

class LauncherBridge {
  static const MethodChannel _channel = MethodChannel('com.sparkos.launcher/bridge');

  // Forces the system level default picker overlay if registration drops
  static Future<void> openDefaultHomePicker() async {
    try {
      await _channel.invokeMethod('triggerHomePicker');
    } on PlatformException catch (e) {
      print("Failed to invoke platform bridge: \${e.message}");
    }
  }
}
