import 'package:flutter/services.dart';

class LauncherService {
  static const MethodChannel _channel =
      MethodChannel('com.sparkos.launcher/bridge');

  Future<bool> isDefaultLauncher() async {
    try {
      final bool isDefault = await _channel.invokeMethod('isDefaultLauncher');
      return isDefault;
    } on PlatformException catch (e) {
      print("Failed to check if default launcher: ${e.message}");
      return false;
    }
  }
}
