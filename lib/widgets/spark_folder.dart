import 'package:flutter/material.dart';
import 'dart:math';
import '../core/animations.dart';
import '../core/colors.dart';
import '../models/app_model.dart';

class ConstellationFolder extends StatefulWidget {
  final String folderName;
  final List<AppModel> apps;
  final double orbitalPosition; // angle on the ring

  const ConstellationFolder({
    Key? key,
    required this.folderName,
    required this.apps,
    this.orbitalPosition = 0.0,
  }) : super(key: key);

  @override
  State<ConstellationFolder> createState() => _ConstellationFolderState();
}

class _ConstellationFolderState extends State<ConstellationFolder>
    with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: SparkAnimations.sparkExpandCurve,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleFolder() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleFolder,
      child: _isOpen ? _buildOpenFolder() : _buildClosedCluster(),
    );
  }

  Widget _buildClosedCluster() {
    return CustomPaint(
      size: const Size(24, 24),
      painter: _ClusterPainter(appCount: widget.apps.length),
    );
  }

  Widget _buildOpenFolder() {
    return AnimatedBuilder(
      animation: _expandAnimation,
      builder: (context, child) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Folder background
            Container(
              width: 120 * _expandAnimation.value,
              height: 120 * _expandAnimation.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: SparkColors.amber.withOpacity(0.3),
                  width: 0.5,
                ),
                color: Colors.black.withOpacity(0.95),
                boxShadow: [
                  BoxShadow(
                    color: SparkColors.amber.withOpacity(0.15),
                    blurRadius: 20,
                  ),
                ],
              ),
            ),

            // Mini star at center
            Center(
              child: Opacity(
                opacity: _expandAnimation.value,
                child: CustomPaint(
                  size: Size(20 * _expandAnimation.value, 20 * _expandAnimation.value),
                  painter: _MiniClusterStarPainter(),
                ),
              ),
            ),

            // Orbiting apps
            ...List.generate(widget.apps.length, (index) {
              final angle = (2 * pi / widget.apps.length) * index;
              final radius = 45 * _expandAnimation.value;
              final x = cos(angle) * radius;
              final y = sin(angle) * radius;

              return Positioned(
                left: 60 + x - 18,
                top: 60 + y - 18,
                child: Opacity(
                  opacity: _expandAnimation.value,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: SparkColors.amber.withOpacity(0.4),
                        width: 0.5,
                      ),
                    ),
                    child: Icon(
                      widget.apps[index].icon,
                      color: SparkColors.amber.withOpacity(0.7),
                      size: 18,
                    ),
                  ),
                ),
              );
            }),

            // Folder name
            Positioned(
              bottom: -20,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: _expandAnimation.value,
                child: Text(
                  widget.folderName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: SparkColors.amber.withOpacity(0.6),
                    fontSize: 10,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ClusterPainter extends CustomPainter {
  final int appCount;

  _ClusterPainter({required this.appCount});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final random = Random(appCount * 13);

    final dotPaint = Paint()
      ..color = SparkColors.amber.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < min(appCount, 4); i++) {
      final x = center.dx + (random.nextDouble() - 0.5) * 12;
      final y = center.dy + (random.nextDouble() - 0.5) * 12;
      canvas.drawCircle(Offset(x, y), 2.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ClusterPainter oldDelegate) => false;
}

class _MiniClusterStarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2;
    final paint = Paint()
      ..color = SparkColors.amber.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    final path = Path();
    for (int i = 0; i < 4; i++) {
      final a1 = (pi / 2) * i - pi / 4;
      final a2 = a1 + pi / 4;
      if (i == 0) path.moveTo(center.dx + cos(a1) * r, center.dy + sin(a1) * r);
      else path.lineTo(center.dx + cos(a1) * r, center.dy + sin(a1) * r);
      path.lineTo(center.dx + cos(a2) * r * 0.35, center.dy + sin(a2) * r * 0.35);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _MiniClusterStarPainter oldDelegate) => false;
}
