import 'package:flutter/material.dart';

class WidgetHost extends StatelessWidget {
  const WidgetHost({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: const Center(
        child: Text(
          'Widget Host Area',
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
