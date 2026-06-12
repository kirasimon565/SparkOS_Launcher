import 'dart:typed_data';
import 'package:flutter/material.dart';

class SparkIcon extends StatefulWidget {
  final Uint8List? iconBytes;
  final String label;
  final VoidCallback onTap;

  const SparkIcon({
    super.key,
    this.iconBytes,
    required this.label,
    required this.onTap,
  });

  @override
  State<SparkIcon> createState() => _SparkIconState();
}

class _SparkIconState extends State<SparkIcon> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: _isPressed
                  ? [
                      BoxShadow(
                        color: Colors.amber.withValues(alpha: 0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      )
                    ]
                  : [],
            ),
            child: widget.iconBytes != null
                ? Image.memory(widget.iconBytes!, width: 56, height: 56)
                : const Icon(Icons.android, size: 56, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            widget.label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
