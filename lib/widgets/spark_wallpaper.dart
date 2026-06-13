import 'package:flutter/material.dart';

class SparkWallpaper extends StatelessWidget {
  final String? imagePath;
  final Widget? child;

  const SparkWallpaper({
    Key? key,
    this.imagePath = '',
    this.child = const SizedBox.shrink(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black, // Fallback
        image: imagePath != null && imagePath!.isNotEmpty
            ? DecorationImage(
                image: AssetImage(imagePath!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: child,
    );
  }
}
