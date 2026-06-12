import 'package:flutter/material.dart';

class SparkButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color outlineColor;

  const SparkButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.outlineColor = Colors.amber,
  }) ;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: outlineColor, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: outlineColor,
          letterSpacing: 2.0,
          fontSize: 16,
        ),
      ),
    );
  }
}
