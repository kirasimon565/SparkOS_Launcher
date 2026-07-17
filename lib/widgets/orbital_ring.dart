import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:typed_data';
import '../core/animations.dart';
import '../core/colors.dart';
import '../models/app_model.dart';

class OrbitalRing extends StatefulWidget {
  final List<AppModel> apps;
  final double starSize;
  final VoidCallback? onAppTap;
  final Function(AppModel)? onAppSelected;
  final bool isInteractive;

  const OrbitalRing({
    Key? key,
    required this.apps,
    this.starSize = 48.0,
    this.onAppTap,
    this.onAppSelected,
    this.isInteractive = true,
  }) : super(key: key);

  @override
  State<OrbitalRing> createState() => _OrbitalRingState();
}

class _OrbitalRingState extends State<OrbitalRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;
  double _currentAngle = 0.0;
  int? _highlightedIndex;
  double _speedMultiplier = 1.0;

  static const double _ringWidth = 300.0;
  static const double _ringHeight = 200.0;
  static const double _iconSize = 44.0;
  static const double _favoriteIconSize = 48.0;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 120),
      vsync: this,
    )..repeat();
    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * pi).animate(_rotationController);
    _rotationController.addListener(() {
      setState(() {
        _currentAngle = _rotationAnimation.value * _speedMultiplier;
        _findHighlightedApp();
      });
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void _findHighlightedApp() {
    if (widget.apps.isEmpty) return;
    double minDistance = double.infinity;
    int closestIndex = 0;
    for (int i = 0; i < widget.apps.length; i++) {
      final pos = _getIconPosition(i);
      final bottom = Offset(_ringWidth / 2, _ringHeight + _iconSize);
      final dist = (pos - bottom).distance;
      if (dist < minDistance) { minDistance = dist; closestIndex = i; }
    }
    _highlightedIndex = closestIndex;
  }

  Offset _getIconPosition(int index) {
    if (widget.apps.isEmpty) return Offset(_ringWidth / 2, _ringHeight / 2);
    final angleStep = (2 * pi) / widget.apps.length;
    final angle = angleStep * index + _currentAngle;
    final app = widget.apps[index];
    final rx = (_ringWidth / 2) * app.orbitalDistance;
    final ry = (_ringHeight / 2) * app.orbitalDistance;
    return Offset(_ringWidth / 2 + cos(angle) * rx, _ringHeight / 2 + sin(angle) * ry);
  }

  void onUserInteraction() {
    setState(() => _speedMultiplier = 2.0);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _speedMultiplier = 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayApps = widget.apps.take(12).toList();
    return GestureDetector(
      onTapDown: (_) => onUserInteraction(),
      child: SizedBox(
        width: _ringWidth + _iconSize * 2,
        height: _ringHeight + _iconSize * 2,
        child: Stack(
          children: [
            CustomPaint(
              size: Size(_ringWidth + _iconSize * 2, _ringHeight + _iconSize * 2),
              painter: _OrbitalRingPainter(apps: displayApps, currentAngle: _currentAngle),
            ),
            ...List.generate(displayApps.length, (index) {
              final pos = _getIconPosition(index);
              final isHighlighted = index == _highlightedIndex;
              final app = displayApps[index];
              final size = app.isFavorite ? _favoriteIconSize : _iconSize;

              return Positioned(
                left: pos.dx - size / 2 + _iconSize,
                top: pos.dy - size / 2 + _iconSize,
                child: GestureDetector(
                  onTap: () => widget.onAppSelected?.call(app),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isHighlighted ? SparkColors.amber.withOpacity(0.8) : SparkColors.amber.withOpacity(0.15),
                        width: isHighlighted ? 1.0 : 0.5,
                      ),
                      boxShadow: isHighlighted ? [
                        BoxShadow(color: SparkColors.amber.withOpacity(0.3), blurRadius: 8, spreadRadius: 1)
                      ] : [],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(size / 2),
                      child: app.iconBytes != null
                          ? Image.memory(app.iconBytes!, width: size * 0.7, height: size * 0.7)
                          : Icon(Icons.apps, color: SparkColors.amber.withOpacity(0.6), size: size * 0.5),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _OrbitalRingPainter extends CustomPainter {
  final List<AppModel> apps;
  final double currentAngle;

  _OrbitalRingPainter({required this.apps, required this.currentAngle});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final ringPaint = Paint()
      ..color = SparkColors.amber.withOpacity(0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    final ringRect = Rect.fromCenter(center: center, width: _OrbitalRingState._ringWidth, height: _OrbitalRingState._ringHeight);
    canvas.drawOval(ringRect, ringPaint);
  }

  @override
  bool shouldRepaint(covariant _OrbitalRingPainter oldDelegate) => oldDelegate.currentAngle != currentAngle;
}
