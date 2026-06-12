import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/settings_service.dart';

class ThemesScreen extends ConsumerWidget {
  const ThemesScreen({super.key}) ;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final themes = ['ember', 'ash', 'eclipse', 'aurora'];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Themes'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: themes.length,
        itemBuilder: (context, index) {
          final themeName = themes[index];
          final isSelected = settings.activeTheme == themeName;

          return ListTile(
            title: Text(
              themeName.toUpperCase(),
              style: TextStyle(
                color: isSelected ? Colors.amber : Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            trailing: isSelected ? const Icon(Icons.check, color: Colors.amber) : null,
            onTap: () {
              ref.read(settingsProvider.notifier).setTheme(themeName);
            },
          );
        },
      ),
    );
  }
}
