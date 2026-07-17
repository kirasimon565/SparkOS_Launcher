import 'package:flutter/material.dart';
import '../../core/animations.dart';
import '../../core/colors.dart';

class BirthOfStar extends StatefulWidget {
  final VoidCallback? onComplete;

  const BirthOfStar({Key? key, this.onComplete}) : super(key: key);

  @override
  State<BirthOfStar> createState() => _BirthOfStarState();
}

class _BirthOfStarState extends State<BirthOfStar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _particlePulse;
  late Animation<double> _starIgnite;
  late Animation<double> _ringFadeIn;
  late Animation<double> _textFadeIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );

    _particlePulse = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeInOut),
      ),
    );

    _starIgnite = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _ringFadeIn = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 0.85, curve: Curves.easeOut),
      ),
    );

    _textFadeIn = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.8, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 500), () {
          widget.onComplete?.call();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            size: MediaQuery.of(context).size,
            painter: _BirthPainter(
              particlePulse: _particlePulse.value,
              starIgnite: _starIgnite.value,
              ringFadeIn: _ringFadeIn.value,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 300),
                  Opacity(
                    opacity: _textFadeIn.value,
                    child: const Text(
                      'The spark is awake.',
                      style: TextStyle(
                        color: Color(0xFFE6A800),
                        fontSize: 18,
                        letterSpacing: 3.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _BirthPainter extends CustomPainter {
  final double particlePulse;
  final double starIgnite;
  final double ringFadeIn;

  _BirthPainter({
    required this.particlePulse,
    required this.starIgnite,
    required this.ringFadeIn,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Phase 1: Tiny particle pulsing
    if (particlePulse < 1.0 && starIgnite <= 0) {
      final pulseRadius = 3.0 + sin(particlePulse * pi * 3) * 1.5;
      final paint = Paint()
        ..color = SparkColors.amber.withOpacity(particlePulse * 0.8);
      canvas.drawCircle(center, pulseRadius, paint);

      final glow = Paint()
        ..shader = RadialGradient(
          colors: [
            SparkColors.amber.withOpacity(0.5 * particlePulse),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: center, radius: 15));
      canvas.drawCircle(center, 15, glow);
    }

    // Phase 2: Star ignites
    if (starIgnite > 0) {
      final starSize = 48.0 * starIgnite;
      final halfStar = starSize / 2;

      // Outer glow
      final glowPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            SparkColors.amber.withOpacity(0.4 * starIgnite),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: center, radius: halfStar * 2));
      canvas.drawCircle(center, halfStar * 2, glowPaint);

      // Star shape
      final path = Path();
      final r = halfStar;
      for (int i = 0; i < 4; i++) {
        final a1 = (pi / 2) * i - pi / 4;
        final a2 = a1 + pi / 4;
        if (i == 0) path.moveTo(center.dx + cos(a1) * r, center.dy + sin(a1) * r);
        else path.lineTo(center.dx + cos(a1) * r, center.dy + sin(a1) * r);
        path.lineTo(center.dx + cos(a2) * r * 0.35, center.dy + sin(a2) * r * 0.35);
      }
      path.close();

      final starPaint = Paint()..color = SparkColors.amber;
      canvas.drawPath(path, starPaint);

      // Eye opens for first time
      final eyeWidth = 8.0 * starIgnite;
      final eyePaint = Paint()..color = SparkColors.amberWhite;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: center, width: eyeWidth, height: halfStar * 0.6),
          Radius.circular(eyeWidth / 2),
        ),
        eyePaint,
      );
    }

    // Phase 3: Ring fades in
    if (ringFadeIn > 0) {
      final ringPaint = Paint()
        ..color = SparkColors.amber.withOpacity(0.1 * ringFadeIn)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5;
      canvas.drawOval(
        Rect.fromCenter(center: center, width: 300, height: 200),
        ringPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BirthPainter oldDelegate) => true;
}
