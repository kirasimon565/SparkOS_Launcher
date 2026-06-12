import 'package:flutter/services.dart';

class WidgetBridge {
  static const MethodChannel _channel = MethodChannel('spark_launcher/widget_bridge');

  static Future<int?> bindWidget(String providerName) async {
    try {
      final int result = await _channel.invokeMethod('bindWidget', {'providerName': providerName});
      return result;
    } on PlatformException {
      // ignore: avoid_print
      print("Failed to bind widget.");
      return null;
    }
  }
}
