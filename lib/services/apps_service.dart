import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:device_apps/device_apps.dart';
import 'dart:typed_data';
import '../models/app_model.dart';

final appsProvider = NotifierProvider<AppsNotifier, List<AppModel>>(() {
  return AppsNotifier();
});

class AppsNotifier extends Notifier<List<AppModel>> {
  @override
  List<AppModel> build() {
    _initApps();
    return [];
  }

  Future<void> _initApps() async {
    try {
      List<Application> apps = await DeviceApps.getInstalledApplications(
        includeAppIcons: true,
        includeSystemApps: true,
        onlyAppsWithLaunchIntent: true,
      );

      var parsedApps = apps.map((app) {
        Uint8List? iconBytes;
        if (app is ApplicationWithIcon) {
          iconBytes = app.icon;
        }
        return AppModel(
          title: app.appName,
          packageName: app.packageName,
          iconBytes: iconBytes,
          category: _assignCategory(app.packageName),
        );
      }).toList();

      parsedApps.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
      state = parsedApps;
    } catch (e) {
      print("Failed to load apps: \$e");
    }
  }

  String _assignCategory(String packageName) {
    if (packageName.contains('android.contacts') ||
        packageName.contains('messaging')) return 'Communication';
    if (packageName.contains('gallery') || packageName.contains('player'))
      return 'Media';
    if (packageName.contains('settings') ||
        packageName.contains('packageinstaller')) return 'System';
    return 'Tools';
  }

  void launchApp(String packageName) {
    DeviceApps.openApp(packageName);
  }
}
