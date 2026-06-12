import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import '../../services/settings_service.dart';
import '../../widgets/spark_button.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: Lottie.asset('assets/animations/eye_open.json'),
            ),
            const SizedBox(height: 40),
            const Text(
              'A NEW CYCLE BEGINS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                letterSpacing: 8.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 80),
            SparkButton(
              text: 'ENTER',
              onPressed: () {
                ref.read(settingsProvider.notifier).setHasSeenIntro(true);
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
          ],
        ),
      ),
    );
  }
}
