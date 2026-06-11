import 'package:flutter/material.dart';

class IntroVideoScreen extends StatefulWidget {
  const IntroVideoScreen({Key? key}) : super(key: key);

  @override
  _IntroVideoScreenState createState() => _IntroVideoScreenState();
}

class _IntroVideoScreenState extends State<IntroVideoScreen> {
  @override
  void initState() {
    super.initState();
    // Placeholder logic for video playback duration
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/welcome');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CircularProgressIndicator(color: Colors.amber), // Placeholder for video
      ),
    );
  }
}
