import 'package:flutter/material.dart';

class FolderScreen extends StatelessWidget {
  const FolderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.8),
      body: Center(
        child: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.amber.withValues(alpha: 0.5), width: 2),
            color: Colors.black,
          ),
          child: const Center(
            child: Text(
              'Folder Contents',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
