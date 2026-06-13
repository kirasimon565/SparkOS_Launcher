// lib/screens/home/search_bar.dart

import 'package:flutter/material.dart';
import '../../core/animations.dart';
import '../../core/colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Spark Search Bar — Emerges from darkness, fades back when dismissed
// ─────────────────────────────────────────────────────────────────────────────

class SparkSearchBar extends StatefulWidget {
  final VoidCallback onDismiss;
  final AnimationController? fadeAnimation;

  const SparkSearchBar({
    Key? key,
    required this.onDismiss,
    this.fadeAnimation,
  }) : super(key: key);

  @override
  State<SparkSearchBar> createState() => _SparkSearchBarState();
}

class _SparkSearchBarState extends State<SparkSearchBar>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  // Local animation for the glow pulse
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();

    // Glow pulse animation
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    // Auto-focus with a slight delay to let the fade-in complete
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return Container(
          height: 56,
          decoration: BoxDecoration(
            color: SparkColors.darkGray.withOpacity(0.8),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: SparkColors.amber.withOpacity(0.15 + (_glowController.value * 0.1)),
              width: 0.5,
            ),
            boxShadow: [
              // Subtle amber glow that pulses
              BoxShadow(
                color: SparkColors.amber.withOpacity(0.05 + (_glowController.value * 0.08)),
                blurRadius: 20 + (_glowController.value * 10),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            children: [
              // ─── Search Icon ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: Icon(
                  Icons.search_rounded,
                  color: SparkColors.amber.withOpacity(0.6 + (_glowController.value * 0.3)),
                  size: 22,
                ),
              ),

              // ─── Text Field ───────────────────────────────────────────
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  style: const TextStyle(
                    color: SparkColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  cursorColor: SparkColors.amber,
                  cursorWidth: 2,
                  decoration: const InputDecoration(
                    hintText: 'Search apps, contacts, actions...',
                    hintStyle: TextStyle(
                      color: SparkColors.lightGray,
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  onChanged: (value) {
                    // Filter results — will be connected to search logic
                  },
                  onSubmitted: (value) {
                    // Launch top result
                  },
                ),
              ),

              // ─── Clear / Dismiss Button ───────────────────────────────
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: SparkColors.lightGray,
                    size: 20,
                  ),
                  onPressed: widget.onDismiss,
                  splashRadius: 20,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
