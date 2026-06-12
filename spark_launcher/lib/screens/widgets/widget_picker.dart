import 'package:flutter/material.dart';

class WidgetPicker extends StatelessWidget {
  const WidgetPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.9),
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.widgets, color: Colors.amber),
            title: Text('Sample Widget $index', style: const TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
