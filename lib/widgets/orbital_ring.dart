import 'package:flutter/material.dart';
import 'dart:math';
import '../core/animations.dart';
import '../core/colors.dart';

class OrbitalApp {
  final String packageName;
  final String appName;
  final IconData icon;
  final bool isFavorite;
  final double orbitalDistance; // normalized 0.8 to 1.2

  const OrbitalApp({
    required this.packageName,
    required this.appName,
    required this.icon,
    this.isFavorite = false,
    this.orbitalDistance = 1.0,
  });
}

class OrbitalRing extends StatefulWidget {
  final List<OrbitalApp> apps;
  final double starSize;
  final VoidCallback? onAppTap;
  final Function(OrbitalApp)? onAppSelected;
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
  
  // Current angle of the entire ring
  double _currentAngle = 0.0;
  
  // For detecting which icon is nearest to bottom (gravity well)
  int? _highlightedIndex;
  
  // Speed multiplier based on interaction
  double _speedMultiplier = 1.0;

  // Ring dimensions
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
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * pi,
    ).animate(_rotationController);
    
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
    if (widget.apps.isEmpty) {
      _highlightedIndex = null;
      return;
    }
    
    // Find which app is closest to the bottom center
    double minDistance = double.infinity;
    int closestIndex = 0;
    
    for (int i = 0; i < widget.apps.length; i++) {
      final position = _getIconPosition(i);
      final bottomCenter = Offset(
        _ringWidth / 2,
        _ringHeight + _iconSize,
      );
      final distance = (position - bottomCenter).distance;
      if (distance < minDistance) {
        minDistance = distance;
        closestIndex = i;
      }
    }
    
    _highlightedIndex = closestIndex;
  }

  Offset _getIconPosition(int index) {
    final app = widget.apps[index];
    final angleStep = (2 * pi) / widget.apps.length;
    final angle = angleStep * index + _currentAngle;
    
    // Slightly irregular orbit based on orbitalDistance
    final rx = (_ringWidth / 2) * app.orbitalDistance;
    final ry = (_ringHeight / 2) * app.orbitalDistance;
    
    return Offset(
      _ringWidth / 2 + cos(angle) * rx,
      _ringHeight / 2 + sin(angle) * ry,
    );
  }

  void onUserInteraction() {
    setState(() {
      _speedMultiplier = 2.0;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _speedMultiplier = 1.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => onUserInteraction(),
      onPanUpdate: (_) => onUserInteraction(),
      child: SizedBox(
        width: _ringWidth + _iconSize * 2,
        height: _ringHeight + _iconSize * 2,
        child: CustomPaint(
          painter: _OrbitalRingPainter(
            apps: widget.apps,
            currentAngle: _currentAngle,
            highlightedIndex: _highlightedIndex,
            getPosition: _getIconPosition,
          ),
          child: widget.isInteractive
              ? Stack(
                  children: List.generate(widget.apps.length, (index) {
                    final position = _getIconPosition(index);
                    final isHighlighted = index == _highlightedIndex;
                    final app = widget.apps[index];
                    final iconSize = app.isFavorite
                        ? _favoriteIconSize
                        : _iconSize;

                    return Positioned(
                      left: position.dx - iconSize / 2 + _iconSize,
                      top: position.dy - iconSize / 2 + _iconSize,
                      child: GestureDetector(
                        onTap: () {
                          widget.onAppSelected?.call(app);
                          widget.onAppTap?.call();
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: iconSize,
                          height: iconSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isHighlighted
                                  ? SparkColors.amber.withOpacity(0.8)
                                  : SparkColors.amber.withOpacity(0.15),
                              width: isHighlighted ? 1.0 : 0.5,
                            ),
                            boxShadow: isHighlighted
                                ? [
                                    BoxShadow(
                                      color: SparkColors.amber.withOpacity(0.3),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    )
                                  ]
                                : [],
                          ),
                          child: Icon(
                            app.icon,
                            color: isHighlighted
                                ? SparkColors.amber
                                : SparkColors.amber.withOpacity(0.6),
                            size: iconSize * 0.55,
                          ),
                        ),
                      ),
                    );
                  }),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}

class _OrbitalRingPainter extends CustomPainter {
  final List<OrbitalApp> apps;
  final double currentAngle;
  final int? highlightedIndex;
  final Offset Function(int) getPosition;

  _OrbitalRingPainter({
    required this.apps,
    required this.currentAngle,
    required this.highlightedIndex,
    required this.getPosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (apps.isEmpty) {
      // Empty ring - just the faint ellipse
      _drawRingPath(canvas, size, Offset(size.width / 2, size.height / 2));
      return;
    }

    final center = Offset(size.width / 2, size.height / 2);
    
    // Draw the faint orbital path
    _drawRingPath(canvas, size, center);

    // Draw faint connection lines to gravity well apps
    if (highlightedIndex != null) {
      final pos = getPosition(highlightedIndex!);
      final adjustedPos = Offset(
        pos.dx + _OrbitalRingState._iconSize,
        pos.dy + _OrbitalRingState._iconSize,
      );
      
      final linePaint = Paint()
        ..color = SparkColors.amber.withOpacity(0.08)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.3;
      
      canvas.drawLine(center, adjustedPos, linePaint);
    }
  }

  void _drawRingPath(Canvas canvas, Size size, Offset center) {
    final ringPaint = Paint()
      ..color = SparkColors.amber.withOpacity(0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    final ringRect = Rect.fromCenter(
      center: center,
      width: _OrbitalRingState._ringWidth,
      height: _OrbitalRingState._ringHeight,
    );
    canvas.drawOval(ringRect, ringPaint);
  }

  @override
  bool shouldRepaint(covariant _OrbitalRingPainter oldDelegate) {
    return oldDelegate.currentAngle != currentAngle ||
        oldDelegate.highlightedIndex != highlightedIndex;
  }
}
