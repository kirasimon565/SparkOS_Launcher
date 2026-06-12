import 'package:flutter/services.dart';

class PackageManager {
  static const MethodChannel _channel =
      MethodChannel('com.sparkos.launcher/package');

  static Future<void> requestDeletePackage(String packageName) async {
    try {
      await _channel
          .invokeMethod('requestDeletePackage', {'packageName': packageName});
    } on PlatformException catch (e) {
      print("Failed to request package deletion: \${e.message}");
    }
  }
}
