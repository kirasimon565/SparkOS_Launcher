import 'package:flutter/material.dart';
import '../../widgets/spark_star.dart';
import '../../core/colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SparkStar(size: 64, eyeState: EyeState.active),
            const SizedBox(height: 40),
            Text(
              'Spark Launcher',
              style: TextStyle(
                color: SparkColors.amber,
                fontSize: 28,
                fontWeight: FontWeight.w300,
                letterSpacing: 4.0,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'The spark is awake',
              style: TextStyle(
                color: SparkColors.amber.withOpacity(0.6),
                fontSize: 14,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 60),
            GestureDetector(
              onTap: () => Navigator.pushReplacementNamed(context, '/home'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: SparkColors.amber.withOpacity(0.5), width: 1),
                ),
                child: Text(
                  'ENTER',
                  style: TextStyle(
                    color: SparkColors.amber,
                    fontSize: 16,
                    letterSpacing: 3.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
