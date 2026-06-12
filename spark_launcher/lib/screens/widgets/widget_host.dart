import 'package:flutter/material.dart';

class WidgetHost extends StatelessWidget {
  const WidgetHost({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey[900]?.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.2)),
      ),
      child: const Center(
        child: Text(
          'Widget Placeholder',
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
