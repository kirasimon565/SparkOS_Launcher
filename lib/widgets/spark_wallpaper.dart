import 'package:flutter/material.dart';
import 'dart:math';
import '../core/colors.dart';

enum WallpaperType { void_, nebula, particleField, ouroboros, custom }

class SparkWallpaper extends StatefulWidget {
  final WallpaperType type;
  final double overlayOpacity;
  final Widget? child;
  final String? customImagePath;

  const SparkWallpaper({
    Key? key,
    this.type = WallpaperType.void_,
    this.overlayOpacity = 1.0,
    this.child,
    this.customImagePath,
  }) : super(key: key);

  @override
  State<SparkWallpaper> createState() => _SparkWallpaperState();
}

class _SparkWallpaperState extends State<SparkWallpaper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background wallpaper
        _buildWallpaper(),
        // Child content on top
        if (widget.child != null) widget.child!,
      ],
    );
  }

  Widget _buildWallpaper() {
    switch (widget.type) {
      case WallpaperType.void_:
        return Container(color: Colors.black);
      case WallpaperType.nebula:
        return _NebulaWallpaper(controller: _controller);
      case WallpaperType.particleField:
        return _ParticleFieldWallpaper(controller: _controller);
      case WallpaperType.ouroboros:
        return _OuroborosWallpaper(controller: _controller);
      case WallpaperType.custom:
        if (widget.customImagePath != null) {
          return Stack(
            children: [
              Image.asset(
                widget.customImagePath!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              Container(
                color: Colors.black.withOpacity(widget.overlayOpacity),
              ),
            ],
          );
        }
        return Container(color: Colors.black);
    }
  }
}

class _NebulaWallpaper extends StatelessWidget {
  final AnimationController controller;

  const _NebulaWallpaper({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          size: MediaQuery.of(context).size,
          painter: _NebulaPainter(animationValue: controller.value),
        );
      },
    );
  }
}

class _NebulaPainter extends CustomPainter {
  final double animationValue;

  _NebulaPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final random = Random(12345);

    // Nebula clouds
    for (int i = 0; i < 8; i++) {
      final angle = (2 * pi / 8) * i + animationValue * 0.1;
      final dist = size.width * 0.3 + sin(animationValue * 2 + i) * 50;
      final x = center.dx + cos(angle) * dist;
      final y = center.dy + sin(angle) * dist * 0.6;

      final cloudPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFE6A800).withOpacity(0.03),
            const Color(0xFF1A0A2E).withOpacity(0.02),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: Offset(x, y), radius: 120));

      canvas.drawCircle(Offset(x, y), 120, cloudPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _NebulaPainter oldDelegate) => true;
}

class _ParticleFieldWallpaper extends StatelessWidget {
  final AnimationController controller;

  const _ParticleFieldWallpaper({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          size: MediaQuery.of(context).size,
          painter: _ParticleFieldPainter(animationValue: controller.value),
        );
      },
    );
  }
}

class _ParticleFieldPainter extends CustomPainter {
  final double animationValue;

  _ParticleFieldPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final random = Random(67890);

    final paint = Paint()
      ..color = SparkColors.amber.withOpacity(0.06);

    for (int i = 0; i < 60; i++) {
      final baseAngle = random.nextDouble() * 2 * pi;
      final baseDist = random.nextDouble() * size.width * 0.7;
      final drift = animationValue * (random.nextDouble() - 0.5) * 40;

      final x = center.dx + cos(baseAngle + animationValue * 0.05) * (baseDist + drift);
      final y = center.dy + sin(baseAngle + animationValue * 0.05) * (baseDist + drift) * 0.6;

      final particleRadius = random.nextDouble() * 1.2 + 0.3;
      canvas.drawCircle(Offset(x, y), particleRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticleFieldPainter oldDelegate) => true;
}

class _OuroborosWallpaper extends StatelessWidget {
  final AnimationController controller;

  const _OuroborosWallpaper({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          size: MediaQuery.of(context).size,
          painter: _OuroborosPainter(animationValue: controller.value),
        );
      },
    );
  }
}

class _OuroborosPainter extends CustomPainter {
  final double animationValue;

  _OuroborosPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.35;

    final paint = Paint()
      ..color = const Color(0xFF222222).withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final path = Path();
    for (double angle = 0; angle < 2 * pi; angle += 0.05) {
      final rotatedAngle = angle + animationValue * 2 * pi / 60;
      final x = center.dx + cos(rotatedAngle) * radius;
      final y = center.dy + sin(rotatedAngle) * radius * 0.65;

      if (angle == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // Break in the ring
    canvas.drawPath(path, paint);

    // Serpent heads at break
    final breakAngle = animationValue * 2 * pi / 60;
    final headX = center.dx + cos(breakAngle) * radius;
    final headY = center.dy + sin(breakAngle) * radius * 0.65;

    final headPaint = Paint()
      ..color = const Color(0xFF444444).withOpacity(0.5)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(headX, headY), 3, headPaint);
  }

  @override
  bool shouldRepaint(covariant _OuroborosPainter oldDelegate) => true;
}
