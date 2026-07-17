import 'package:flutter/material.dart';
import 'dart:math';
import '../core/animations.dart';
import '../core/colors.dart';

enum EyeState { resting, watching, active, sleeping, alert, error }

class SparkStar extends StatefulWidget {
  final double size;
  final EyeState eyeState;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onLongPress;
  final Function(DragUpdateDetails)? onDragUpdate;
  final Function(DragEndDetails)? onDragEnd;

  const SparkStar({
    Key? key,
    this.size = 48.0,
    this.eyeState = EyeState.resting,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.onDragUpdate,
    this.onDragEnd,
  }) : super(key: key);

  @override
  State<SparkStar> createState() => _SparkStarState();
}

class _SparkStarState extends State<SparkStar>
    with SingleTickerProviderStateMixin {
  late AnimationController _breatheController;
  late Animation<double> _breatheAnimation;

  @override
  void initState() {
    super.initState();
    _breatheController = AnimationController(
      duration: SparkAnimations.breathe,
      vsync: this,
    )..repeat(reverse: true);
    _breatheAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _breatheController,
      curve: SparkAnimations.breatheCurve,
    ));
  }

  @override
  void dispose() {
    _breatheController.dispose();
    super.dispose();
  }

  double get _eyeWidth {
    switch (widget.eyeState) {
      case EyeState.resting: return 2.0;
      case EyeState.watching: return 4.0;
      case EyeState.active: return 8.0;
      case EyeState.sleeping: return 0.5;
      case EyeState.alert: return 6.0;
      case EyeState.error: return 3.0;
    }
  }

  Color get _eyeColor {
    switch (widget.eyeState) {
      case EyeState.error: return const Color(0xFFFF4444);
      default: return SparkColors.amberWhite;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onDoubleTap: widget.onDoubleTap,
      onLongPress: widget.onLongPress,
      onPanUpdate: widget.onDragUpdate,
      onPanEnd: widget.onDragEnd,
      child: AnimatedBuilder(
        animation: _breatheAnimation,
        builder: (context, child) {
          return CustomPaint(
            size: Size(widget.size * _breatheAnimation.value * 2,
                widget.size * _breatheAnimation.value * 2),
            painter: _SparkStarPainter(
              starSize: widget.size * _breatheAnimation.value,
              eyeWidth: _eyeWidth,
              eyeColor: _eyeColor,
              glowOpacity: 0.4 * _breatheAnimation.value,
            ),
          );
        },
      ),
    );
  }
}

class _SparkStarPainter extends CustomPainter {
  final double starSize;
  final double eyeWidth;
  final Color eyeColor;
  final double glowOpacity;

  _SparkStarPainter({
    required this.starSize,
    required this.eyeWidth,
    required this.eyeColor,
    required this.glowOpacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final halfStar = starSize / 2;

    // Outer glow
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          SparkColors.amber.withOpacity(glowOpacity),
          SparkColors.amber.withOpacity(0.0),
        ],
        radius: 1.0,
      ).createShader(Rect.fromCircle(center: center, radius: halfStar * 2))
      ..blendMode = BlendMode.screen;

    canvas.drawCircle(center, halfStar * 2, glowPaint);

    // Inner ring (faint, 72dp diameter, 1dp stroke)
    final ringPaint = Paint()
      ..color = SparkColors.amber.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    canvas.drawCircle(center, halfStar * 1.5, ringPaint);

    // The four-pointed star
    final starPath = Path();
    final outerRadius = halfStar;
    final innerRadius = halfStar * 0.35;
    
    for (int i = 0; i < 4; i++) {
      final outerAngle = (pi / 2) * i - pi / 4;
      final innerAngle = outerAngle + pi / 4;
      
      if (i == 0) {
        starPath.moveTo(
          center.dx + cos(outerAngle) * outerRadius,
          center.dy + sin(outerAngle) * outerRadius,
        );
      } else {
        starPath.lineTo(
          center.dx + cos(outerAngle) * outerRadius,
          center.dy + sin(outerAngle) * outerRadius,
        );
      }
      starPath.lineTo(
        center.dx + cos(innerAngle) * innerRadius,
        center.dy + sin(innerAngle) * innerRadius,
      );
    }
    starPath.close();

    final starPaint = Paint()
      ..color = SparkColors.amber
      ..style = PaintingStyle.fill;
    canvas.drawPath(starPath, starPaint);

    // Star outline (sharper)
    final starStroke = Paint()
      ..color = SparkColors.amberLight
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    canvas.drawPath(starPath, starStroke);

    // The Eye slit
    final eyePaint = Paint()
      ..color = eyeColor
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: center,
          width: eyeWidth,
          height: halfStar * 0.6,
        ),
        Radius.circular(eyeWidth / 2),
      ),
      eyePaint,
    );

    // Eye inner glow
    if (eyeWidth > 1.0) {
      final eyeGlow = Paint()
        ..shader = RadialGradient(
          colors: [
            eyeColor.withOpacity(0.8),
            eyeColor.withOpacity(0.0),
          ],
        ).createShader(Rect.fromCenter(
          center: center,
          width: eyeWidth * 3,
          height: eyeWidth * 3,
        ))
        ..blendMode = BlendMode.screen;
      canvas.drawCircle(center, eyeWidth * 1.5, eyeGlow);
    }
  }

  @override
  bool shouldRepaint(covariant _SparkStarPainter oldDelegate) {
    return oldDelegate.glowOpacity != glowOpacity ||
        oldDelegate.eyeWidth != eyeWidth ||
        oldDelegate.eyeColor != eyeColor;
  }
}
