import 'package:flutter/material.dart';

class SparkPageView extends StatefulWidget {
  const SparkPageView({Key? key}) : super(key: key);

  @override
  _SparkPageViewState createState() => _SparkPageViewState();
}

class _SparkPageViewState extends State<SparkPageView> {
  final PageController _controller = PageController(initialPage: 1000); // Hack for infinite scrolling

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _controller,
      itemBuilder: (context, index) {
        return Center(
          child: Text(
            'Page \${index % 3}', // Placeholder for actual pages
            style: const TextStyle(color: Colors.white, fontSize: 24),
          ),
        );
      },
    );
  }
}
