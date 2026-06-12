import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/routes.dart';
import '../../core/typography.dart';
import '../../widgets/spark_button.dart';
import '../../services/settings_service.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'A NEW CYCLE BEGINS',
              style: SparkTypography.header,
            ),
            const SizedBox(height: 48),
            SparkButton(
              text: 'ENTER',
              onPressed: () {
                ref.read(settingsProvider.notifier).setHasSeenIntro(true);
                Navigator.of(context).pushReplacementNamed(SparkRoutes.home);
              },
            ),
          ],
        ),
      ),
    );
  }
}
