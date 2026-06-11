import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildSettingsTile(context, Icons.palette, 'Appearance', '/settings/appearance'),
          _buildSettingsTile(context, Icons.home, 'Home Screen', '/settings/home'),
          _buildSettingsTile(context, Icons.apps, 'Drawer', '/settings/drawer'),
          _buildSettingsTile(context, Icons.gesture, 'Gestures', '/settings/gestures'),
          _buildSettingsTile(context, Icons.folder, 'Folders', '/settings/folders'),
          _buildSettingsTile(context, Icons.widgets, 'Widgets', '/settings/widgets'),
          _buildSettingsTile(context, Icons.search, 'Search', '/settings/search'),
          _buildSettingsTile(context, Icons.backup, 'Backup', '/settings/backup'),
          _buildSettingsTile(context, Icons.info, 'About', '/settings/about'),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(BuildContext context, IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon, color: Colors.amber),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () => Navigator.pushNamed(context, route),
    );
  }
}
