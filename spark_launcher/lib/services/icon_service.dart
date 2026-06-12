import 'dart:typed_data';
import 'package:flutter/services.dart';

class IconService {
  static const MethodChannel _channel =
      MethodChannel('com.sparkos.launcher/icons');

  Future<Uint8List?> loadIconPack(String packName) async {
    try {
      final Uint8List? iconData =
          await _channel.invokeMethod('loadIconPack', {'packName': packName});
      return iconData;
    } on PlatformException catch (e) {
      print("Failed to load icon pack: ${e.message}");
      return null;
    }
  }
}
