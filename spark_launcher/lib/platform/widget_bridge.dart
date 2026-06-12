import 'package:flutter/services.dart';

class WidgetBridge {
  static const MethodChannel _channel =
      MethodChannel('com.sparkos.launcher/widget');

  static Future<void> bindWidget(int appWidgetId) async {
    try {
      await _channel.invokeMethod('bindWidget', {'appWidgetId': appWidgetId});
    } on PlatformException catch (e) {
      print("Failed to bind widget: \${e.message}");
    }
  }
}
