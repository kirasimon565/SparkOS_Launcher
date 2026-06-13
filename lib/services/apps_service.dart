import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:installed_apps/app_info.dart';
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
      List<AppInfo> apps = await InstalledApps.getInstalledApps(
        excludeSystemApps: false,
        withIcon: true,

      );

      var parsedApps = apps.map((app) {
        Uint8List? iconBytes;
        if (app.icon != null) {
          iconBytes = app.icon;
        }
        return AppModel(
          title: app.name!,
          packageName: app.packageName!,
          iconBytes: iconBytes,
          category: _assignCategory(app.packageName!),
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
    InstalledApps.startApp(packageName);
  }
}
