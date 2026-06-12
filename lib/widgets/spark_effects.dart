import 'package:flutter/material.dart';

class SparkParticle {
  Offset position;
  Offset velocity;
  double alpha;
  double size;

  SparkParticle({
    required this.position,
    required this.velocity,
    this.alpha = 1.0,
    this.size = 2.5,
  });

  void update() {
    position += velocity;
    alpha -= 0.04;
  }
}

class SparkTrailPainter extends CustomPainter {
  final List<SparkParticle> particles;
  final Color sparkColor;

  SparkTrailPainter({required this.particles, required this.sparkColor});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = sparkColor
      ..strokeCap = StrokeCap.round;

    for (var particle in particles) {
      if (particle.alpha <= 0) continue;
      paint.color = sparkColor.withOpacity(particle.alpha);
      canvas.drawCircle(particle.position, particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant SparkTrailPainter oldDelegate) => true;
}
