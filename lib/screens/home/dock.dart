// lib/screens/home/dock.dart

import 'package:flutter/material.dart';
import 'dart:math' as math;

// ─────────────────────────────────────────────────────────────────────────────
// Spark Dock — A living spark that reveals your most important apps
// ─────────────────────────────────────────────────────────────────────────────

class SparkDock extends StatefulWidget {
  final List<DockApp> apps;
  final Color sparkColor;
  final void Function(int index)? onAppTap;
  final void Function(int index)? onAppLongPress;
  final void Function(bool isOpen)? onDockStateChanged;

  const SparkDock({
    Key? key,
    required this.apps,
    this.sparkColor = const Color(0xFFE6A800), // Amber
    this.onAppTap,
    this.onAppLongPress,
    this.onDockStateChanged,
  }) : super(key: key);

  @override
  State<SparkDock> createState() => _SparkDockState();
}

class _SparkDockState extends State<SparkDock>
    with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  bool _isPressed = false;

  late AnimationController _breatheController;
  late AnimationController _expandController;
  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();

    // Breathing animation for the closed spark
    _breatheController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    )..repeat(reverse: true);

    // Expansion animation
    _expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Particle burst animation
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _breatheController.dispose();
    _expandController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  void _toggleDock() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _expandController.forward();
        _particleController.forward(from: 0);
      } else {
        _expandController.reverse();
        _particleController.reverse();
      }
    });

    // Notify parent
    widget.onDockStateChanged?.call(_isOpen);
  }

  void _onPointerDown(_) {
    setState(() => _isPressed = true);
  }

  void _onPointerUp(_) {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // ─────── Energy line connecting icons (visible when open) ───────
          if (_isOpen)
            AnimatedBuilder(
              animation: _expandController,
              builder: (context, child) {
                return Positioned(
                  bottom: 55,
                  left: 40,
                  right: 40,
                  child: Opacity(
                    opacity: _expandController.value.clamp(0.0, 0.4),
                    child: CustomPaint(
                      painter: _EnergyLinePainter(
                        color: widget.sparkColor,
                        progress: _expandController.value,
                      ),
                      size: const Size(double.infinity, 2),
                    ),
                  ),
                );
              },
            ),

          // ─────── App icons (orbit around the spark when open) ───────
          ...List.generate(widget.apps.length, (index) {
            return _buildOrbitingIcon(index);
          }),

          // ─────── Particles (on press) ───────
          if (_isPressed || _expandController.isAnimating)
            AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _SparkParticlePainter(
                    color: widget.sparkColor,
                    progress: _particleController.value,
                  ),
                  size: const Size(120, 120),
                );
              },
            ),

          // ─────── The Spark itself ───────
          GestureDetector(
            onTap: _toggleDock,
            onPanStart: (_) => _onPointerDown(_),
            onPanEnd: (_) => _onPointerUp(_),
            onPanCancel: () => _onPointerUp(_),
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _breatheController,
                _expandController,
              ]),
              builder: (context, child) {
                final breatheValue = _breatheController.value;
                final expandValue = _expandController.value;

                // Scale: breathes 1.0 ↔ 1.1 when closed, stable when open
                final breatheScale = _isOpen
                    ? 1.0
                    : 1.0 + (breatheValue * 0.1);

                // Slight compression on press
                final pressScale = _isPressed ? 0.9 : 1.0;

                final totalScale = breatheScale * pressScale;

                return Container(
                  width: 56,
                  height: 56,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      // Outer glow
                      BoxShadow(
                        color: widget.sparkColor.withOpacity(0.15 + (breatheValue * 0.1)),
                        blurRadius: 24 + (breatheValue * 8),
                        spreadRadius: 4 + (breatheValue * 2),
                      ),
                      // Inner glow
                      BoxShadow(
                        color: widget.sparkColor.withOpacity(0.3 + (breatheValue * 0.15)),
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Transform.scale(
                    scale: totalScale,
                    child: CustomPaint(
                      painter: _SparkCorePainter(
                        color: widget.sparkColor,
                        isOpen: _isOpen,
                        expandProgress: expandValue,
                        breatheValue: breatheValue,
                      ),
                      size: const Size(56, 56),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrbitingIcon(int index) {
    final totalApps = widget.apps.length;
    if (totalApps == 0) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _expandController,
      builder: (context, child) {
        final progress = _expandController.value;

        // Calculate position in the orbit
        // Central spark is at bottom center
        // Icons spread horizontally outward from the spark
        final centerIndex = (totalApps - 1) / 2.0;
        final offset = index - centerIndex;

        // Spacing between icons
        final spacing = 64.0;
        final xOffset = offset * spacing * progress;

        // Icons rise slightly as they appear
        final yOffset = -8 * progress;

        // Scale from 0 to 1 as they emerge
        final scale = progress.clamp(0.0, 1.0);
        final opacity = progress.clamp(0.0, 1.0);

        return Positioned(
          bottom: 50 + yOffset,
          left: null,
          right: null,
          child: Transform.translate(
            offset: Offset(xOffset, 0),
            child: Transform.scale(
              scale: scale,
              child: Opacity(
                opacity: opacity,
                child: GestureDetector(
                  onTap: () => widget.onAppTap?.call(index),
                  onLongPress: () => widget.onAppLongPress?.call(index),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: widget.sparkColor.withOpacity(0.1),
                          blurRadius: 12,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: widget.apps[index].icon,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Dock App Model
// ─────────────────────────────────────────────────────────────────────────────

class DockApp {
  final Widget icon;
  final String label;
  final VoidCallback? onTap;

  const DockApp({
    required this.icon,
    this.label = '',
    this.onTap,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Custom Painters
// ─────────────────────────────────────────────────────────────────────────────

/// Paints the glowing core of the spark
class _SparkCorePainter extends CustomPainter {
  final Color color;
  final bool isOpen;
  final double expandProgress;
  final double breatheValue;

  _SparkCorePainter({
    required this.color,
    required this.isOpen,
    required this.expandProgress,
    required this.breatheValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width / 3;

    if (isOpen) {
      // Open state: horizontally stretched spark
      final stretchX = 1.0 + (expandProgress * 1.5);
      final stretchY = 1.0 - (expandProgress * 0.3);

      // Outer glow
      final outerPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            color.withOpacity(0.4),
            color.withOpacity(0.0),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: baseRadius * 2));

      canvas.drawCircle(center, baseRadius * 2, outerPaint);

      // Core shape
      final corePaint = Paint()
        ..shader = RadialGradient(
          colors: [
            color.withOpacity(0.9),
            color.withOpacity(0.3),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: baseRadius));

      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.scale(stretchX, stretchY);
      canvas.drawCircle(Offset.zero, baseRadius, corePaint);

      // Bright center point
      final brightPaint = Paint()
        ..color = color.withOpacity(1.0)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

      canvas.drawCircle(Offset.zero, baseRadius * 0.3, brightPaint);
      canvas.restore();
    } else {
      // Closed state: a living spark ✦
      final sparkRadius = baseRadius * (1.0 + (breatheValue * 0.15));

      // Outer glow
      final outerGlow = Paint()
        ..shader = RadialGradient(
          colors: [
            color.withOpacity(0.25),
            color.withOpacity(0.05),
            color.withOpacity(0.0),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: sparkRadius * 3));

      canvas.drawCircle(center, sparkRadius * 3, outerGlow);

      // Middle glow
      final midGlow = Paint()
        ..shader = RadialGradient(
          colors: [
            color.withOpacity(0.6),
            color.withOpacity(0.15),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: sparkRadius * 1.5));

      canvas.drawCircle(center, sparkRadius * 1.5, midGlow);

      // Core — diamond/spark shape ✦
      final sparkPath = Path();
      final r = sparkRadius;
      final points = 4; // 4-pointed spark

      for (int i = 0; i < points * 2; i++) {
        final angle = (i * math.pi / points) - (math.pi / 2);
        final pointRadius = i.isEven ? r : r * 0.35;
        final x = center.dx + pointRadius * math.cos(angle);
        final y = center.dy + pointRadius * math.sin(angle);

        if (i == 0) {
          sparkPath.moveTo(x, y);
        } else {
          sparkPath.lineTo(x, y);
        }
      }
      sparkPath.close();

      final sparkPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.white.withOpacity(0.9),
            color.withOpacity(0.8),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: r));

      canvas.drawPath(sparkPath, sparkPaint);

      // Central bright point
      final centerPaint = Paint()
        ..color = Colors.white.withOpacity(0.95)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);

      canvas.drawCircle(center, r * 0.18, centerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SparkCorePainter oldDelegate) => true;
}

/// Paints the subtle energy line connecting icons
class _EnergyLinePainter extends CustomPainter {
  final Color color;
  final double progress;

  _EnergyLinePainter({required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.15 * progress.clamp(0.0, 1.0))
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    final path = Path();
    path.moveTo(0, size.height / 2);
    path.lineTo(size.width, size.height / 2);

    canvas.drawPath(path, paint);

    // Brighter center near the spark
    final centerPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withOpacity(0.3 * progress.clamp(0.0, 1.0)),
          color.withOpacity(0.0),
        ],
      ).createShader(Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: 80,
        height: 4,
      ));

    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: 80,
        height: 4,
      ),
      centerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _EnergyLinePainter oldDelegate) => true;
}

/// Paints faint particles around the spark on press
class _SparkParticlePainter extends CustomPainter {
  final Color color;
  final double progress;

  _SparkParticlePainter({required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final rng = math.Random(42); // Fixed seed for consistent particles

    final particleCount = 5;
    for (int i = 0; i < particleCount; i++) {
      final angle = (i / particleCount) * 2 * math.pi + (progress * 0.5);
      final distance = 20 + (progress * 25) + (rng.nextDouble() * 10);
      final x = center.dx + distance * math.cos(angle);
      final y = center.dy + distance * math.sin(angle);
      final particleRadius = 2.0 * (1.0 - progress).clamp(0.2, 1.0);
      final opacity = (1.0 - progress).clamp(0.0, 0.6);

      final paint = Paint()
        ..color = color.withOpacity(opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

      canvas.drawCircle(Offset(x, y), particleRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SparkParticlePainter oldDelegate) => true;
}

// ─────────────────────────────────────────────────────────────────────────────
// AnimatedBuilder helper (since Flutter uses AnimatedBuilder for single
// animation, we need a multi-animation version or use Listenable.merge)
// ─────────────────────────────────────────────────────────────────────────────

class AnimatedBuilder extends StatelessWidget {
  final Listenable animation;
  final Widget? child;
  final Widget Function(BuildContext context, Widget? child) builder;

  const AnimatedBuilder({
    Key? key,
    required this.animation,
    this.child,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilderImpl(
      animation: animation,
      builder: builder,
      child: child,
    );
  }
}

class AnimatedBuilderImpl extends AnimatedWidget {
  final Widget? child;
  final Widget Function(BuildContext context, Widget? child) builder;

  const AnimatedBuilderImpl({
    Key? key,
    required Listenable animation,
    required this.builder,
    this.child,
  }) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    return builder(context, child);
  }
}
