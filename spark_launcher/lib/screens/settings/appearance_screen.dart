import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/settings_service.dart';

class AppearanceScreen extends ConsumerWidget {
  const AppearanceScreen({super.key}) ;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Appearance'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Grid Columns', style: TextStyle(color: Colors.white)),
            trailing: DropdownButton<int>(
              value: settings.gridColumns,
              dropdownColor: Colors.grey[900],
              style: const TextStyle(color: Colors.white),
              items: [3, 4, 5, 6].map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                   ref.read(settingsProvider.notifier).setGridColumns(newValue);
                }
              },
            ),
          ),
          SwitchListTile(
            title: const Text('Page Loop', style: TextStyle(color: Colors.white)),
            value: settings.pageLoopEnabled,
            activeThumbColor: Colors.amber,
            onChanged: (bool value) {
              ref.read(settingsProvider.notifier).setPageLoop(value);
            },
          ),
        ],
      ),
    );
  }
}
