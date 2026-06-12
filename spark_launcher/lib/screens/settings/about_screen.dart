import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/settings_service.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.remove_red_eye, size: 80, color: Colors.amber),
            const SizedBox(height: 24),
            const Text(
              'Spark Launcher V2',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 8),
            const Text(
              'A spark awakening inside an endless cycle.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                ref.read(settingsProvider.notifier).setHasSeenIntro(false);
                Navigator.pushNamedAndRemoveUntil(
                    context, '/intro', (route) => false);
              },
              child: const Text('Replay Welcome Experience'),
            ),
          ],
        ),
      ),
    );
  }
}
