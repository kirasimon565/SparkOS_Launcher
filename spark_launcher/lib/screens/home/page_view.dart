import 'package:flutter/material.dart';
import '../../widgets/spark_card.dart';

class SparkPageView extends StatefulWidget {
  const SparkPageView({super.key});

  @override
  State<SparkPageView> createState() => _SparkPageViewState();
}

class _SparkPageViewState extends State<SparkPageView> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: 3,
      itemBuilder: (context, index) {
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 48, 16, 120),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 24,
          ),
          itemCount: 16,
          itemBuilder: (context, gridIndex) {
            return const SparkCard(
              child: Center(
                child: Icon(Icons.apps, color: Colors.amber),
              ),
            );
          },
        );
      },
    );
  }
}
