import 'package:flutter/material.dart';

class SparkFolderIcon extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const SparkFolderIcon({Key? key, required this.title, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
              border: Border.all(color: Colors.amber, width: 2),
            ),
            child: const Center(
              child: Icon(Icons.folder, color: Colors.white, size: 24),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          )
        ],
      ),
    );
  }
}
