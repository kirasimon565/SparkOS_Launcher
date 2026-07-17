import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_model.dart';

final appsProvider = FutureProvider<List<AppModel>>((ref) async {
  return await AppsService.loadApps();
});

class AppsService {
  static const MethodChannel _channel = MethodChannel('com.sparkos.launcher/apps');

  static Future<List<AppModel>> loadApps() async {
    try {
      final List<dynamic>? result = await _channel.invokeMethod('getInstalledApps');
      if (result == null) return [];

      return result.map((app) {
        final map = Map<String, dynamic>.from(app);
        return AppModel(
          packageName: map['packageName'] as String? ?? '',
          name: map['name'] as String? ?? 'Unknown',
          hasNotification: false,
          orbitalDistance: 0.85 + (result.indexOf(app) % 10) * 0.03,
        );
      }).toList();
    } catch (e) {
      return [
        const AppModel(packageName: 'phone', name: 'Phone', orbitalDistance: 0.9),
        const AppModel(packageName: 'messages', name: 'Messages', orbitalDistance: 1.1),
        const AppModel(packageName: 'camera', name: 'Camera', orbitalDistance: 0.85),
        const AppModel(packageName: 'chrome', name: 'Chrome', orbitalDistance: 1.05),
        const AppModel(packageName: 'gallery', name: 'Gallery', orbitalDistance: 1.15),
        const AppModel(packageName: 'music', name: 'Music', orbitalDistance: 0.95),
        const AppModel(packageName: 'settings', name: 'Settings', orbitalDistance: 1.0),
        const AppModel(packageName: 'maps', name: 'Maps', orbitalDistance: 1.2),
      ];
    }
  }

  static Future<Uint8List?> getAppIcon(String packageName) async {
    try {
      final Uint8List? icon = await _channel.invokeMethod('getAppIcon', {'packageName': packageName});
      return icon;
    } catch (e) {
      return null;
    }
  }
}
