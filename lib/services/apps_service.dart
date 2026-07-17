import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:installed_apps/app_info.dart';
import '../models/app_model.dart';

final appsProvider = FutureProvider<List<AppModel>>((ref) async {
  return await AppsService.loadApps();
});

class AppsService {
  static Future<List<AppModel>> loadApps() async {
    try {
      final List<AppInfo> installedApps = await InstalledApps.getInstalledApps(
        includeSystemApps: false,
        onlyAppsWithLaunchIntent: true,
      );

      // Sort alphabetically
      installedApps.sort((a, b) => a.name.compareTo(b.name));

      // Filter out Spark Launcher itself
      final filtered = installedApps
          .where((app) => app.packageName != 'com.sparkos.launcher')
          .toList();

      return filtered.map((app) {
        return AppModel(
          packageName: app.packageName,
          name: app.name,
          hasNotification: false,
          orbitalDistance: 0.85 + (filtered.indexOf(app) % 10) * 0.03,
        );
      }).toList();
    } catch (e) {
      // Fallback: return empty list
      return [];
    }
  }

  static Future<Uint8List?> getAppIcon(String packageName) async {
    try {
      return await InstalledApps.getAppIcon(packageName);
    } catch (e) {
      return null;
    }
  }
}
