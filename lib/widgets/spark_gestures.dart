import 'package:flutter/material.dart';
import 'dart:math';
import '../core/animations.dart';
import '../core/colors.dart';

enum SparkGesture {
  tap,
  doubleTap,
  longPress,
  dragUp,
  dragDown,
  dragLeft,
  dragRight,
  pinch,
}

class SparkGestureDetector extends StatefulWidget {
  final Widget child;
  final Function(SparkGesture)? onGesture;
  final Function(Offset)? onDragUpdate;
  final Function(Offset, double)? onPinchUpdate;

  const SparkGestureDetector({
    Key? key,
    required this.child,
    this.onGesture,
    this.onDragUpdate,
    this.onPinchUpdate,
  }) : super(key: key);

  @override
  State<SparkGestureDetector> createState() => _SparkGestureDetectorState();
}

class _SparkGestureDetectorState extends State<SparkGestureDetector> {
  Offset? _dragStart;
  Offset? _lastDragPosition;
  double _dragDistance = 0.0;
  bool _isDragging = false;
  bool _dragFromStar = false;

  // Pinch tracking
  double? _initialPinchDistance;
  double _pinchScale = 1.0;

  // Long press detection
  bool _longPressTriggered = false;

  // Tap tracking for double-tap
  DateTime? _lastTapTime;
  static const Duration _doubleTapWindow = Duration(milliseconds: 300);

  // Drag thresholds
  static const double _dragThreshold = 40.0;
  static const double _pinchThreshold = 0.3;

  double _getDistance(Offset a, Offset b) {
    return (a - b).distance;
  }

  void _handleTapDown(TapDownDetails details) {
    _dragStart = details.localPosition;
    _lastDragPosition = details.localPosition;
    _dragDistance = 0.0;
    _isDragging = false;
    _longPressTriggered = false;
    _dragFromStar = _isNearStar(details.localPosition);
  }

  void _handleTapUp(TapUpDetails details) {
    if (_longPressTriggered) return;

    final now = DateTime.now();
    if (_lastTapTime != null &&
        now.difference(_lastTapTime!) < _doubleTapWindow) {
      // Double tap
      widget.onGesture?.call(SparkGesture.doubleTap);
      _lastTapTime = null;
    } else {
      // Single tap
      _lastTapTime = now;
      Future.delayed(_doubleTapWindow, () {
        if (_lastTapTime == now && !_longPressTriggered) {
          widget.onGesture?.call(SparkGesture.tap);
        }
      });
    }
  }

  void _handlePanStart(DragStartDetails details) {
    _dragStart = details.localPosition;
    _lastDragPosition = details.localPosition;
    _dragDistance = 0.0;
    _isDragging = true;
    _dragFromStar = _isNearStar(details.localPosition);
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (!_isDragging) return;

    _lastDragPosition = details.localPosition;
    _dragDistance += details.delta.distance;

    widget.onDragUpdate?.call(details.localPosition);

    if (_dragDistance > _dragThreshold) {
      final dx = details.localPosition.dx - _dragStart!.dx;
      final dy = details.localPosition.dy - _dragStart!.dy;

      if (dx.abs() > dy.abs()) {
        // Horizontal drag
        if (dx > 0 && _dragFromStar) {
          widget.onGesture?.call(SparkGesture.dragRight);
        } else if (_dragFromStar) {
          widget.onGesture?.call(SparkGesture.dragLeft);
        }
      } else {
        // Vertical drag
        if (dy < 0 && _dragFromStar) {
          widget.onGesture?.call(SparkGesture.dragUp);
        } else if (_dragFromStar) {
          widget.onGesture?.call(SparkGesture.dragDown);
        }
      }
      _resetDrag();
    }
  }

  void _handlePanEnd(DragEndDetails details) {
    _isDragging = false;
    _dragStart = null;
    _lastDragPosition = null;
    _dragDistance = 0.0;
    _dragFromStar = false;
  }

  void _handleLongPress(LongPressStartDetails details) {
    if (_isNearStar(details.localPosition)) {
      _longPressTriggered = true;
      widget.onGesture?.call(SparkGesture.longPress);
    }
  }

  void _handleLongPressEnd(LongPressEndDetails details) {
    _longPressTriggered = false;
  }

  void _handleScaleStart(ScaleStartDetails details) {
    if (details.pointerCount >= 2) {
      _initialPinchDistance = _getDistance(
        details.localFocalPoint,
        details.localFocalPoint + const Offset(10, 0),
      );
      _pinchScale = 1.0;
    }
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    if (_initialPinchDistance != null && details.pointerCount >= 2) {
      final newDistance = _getDistance(
        details.localFocalPoint,
        details.localFocalPoint + const Offset(10, 0),
      );
      _pinchScale = newDistance / _initialPinchDistance!;

      if (_pinchScale < 1.0 - _pinchThreshold) {
        widget.onGesture?.call(SparkGesture.pinch);
        _initialPinchDistance = null;
        _pinchScale = 1.0;
      }

      widget.onPinchUpdate?.call(details.localFocalPoint, _pinchScale);
    }
  }

  void _handleScaleEnd(ScaleEndDetails details) {
    _initialPinchDistance = null;
    _pinchScale = 1.0;
  }

  bool _isNearStar(Offset position) {
    final size = context.size;
    if (size == null) return false;
    final center = Offset(size.width / 2, size.height / 2);
    return _getDistance(position, center) < 100.0; // 100dp radius from star
  }

  void _resetDrag() {
    _isDragging = false;
    _dragStart = null;
    _dragDistance = 0.0;
    _dragFromStar = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onPanStart: _handlePanStart,
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      onLongPressStart: _handleLongPressStart,
      onLongPressEnd: _handleLongPressEnd,
      onScaleStart: _handleScaleStart,
      onScaleUpdate: _handleScaleUpdate,
      onScaleEnd: _handleScaleEnd,
      behavior: HitTestBehavior.translucent,
      child: widget.child,
    );
  }
}

class CircularMenu extends StatelessWidget {
  final bool isVisible;
  final VoidCallback? onSearch;
  final VoidCallback? onSettings;
  final VoidCallback? onPower;
  final VoidCallback? onOverview;
  final double starSize;

  const CircularMenu({
    Key? key,
    this.isVisible = false,
    this.onSearch,
    this.onSettings,
    this.onPower,
    this.onOverview,
    this.starSize = 48.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: SparkAnimations.medium,
      child: AnimatedScale(
        scale: isVisible ? 1.0 : 0.0,
        duration: SparkAnimations.medium,
        curve: SparkAnimations.sparkExpandCurve,
        child: SizedBox(
          width: 200,
          height: 200,
          child: Stack(
            children: [
              _MenuItem(
                icon: Icons.search,
                label: 'Search',
                angle: -pi / 2, // Top
                distance: 96,
                onTap: onSearch,
              ),
              _MenuItem(
                icon: Icons.settings,
                label: 'Settings',
                angle: 0, // Right
                distance: 96,
                onTap: onSettings,
              ),
              _MenuItem(
                icon: Icons.power_settings_new,
                label: 'Power',
                angle: pi / 2, // Bottom
                distance: 96,
                onTap: onPower,
              ),
              _MenuItem(
                icon: Icons.apps,
                label: 'Overview',
                angle: pi, // Left
                distance: 96,
                onTap: onOverview,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final double angle;
  final double distance;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.angle,
    required this.distance,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final center = const Offset(100, 100);
    final x = center.dx + cos(angle) * distance - 24;
    final y = center.dy + sin(angle) * distance - 24;

    return Positioned(
      left: x,
      top: y,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: SparkColors.amber.withOpacity(0.5),
                  width: 0.8,
                ),
                boxShadow: [
                  BoxShadow(
                    color: SparkColors.amber.withOpacity(0.2),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: SparkColors.amber,
                size: 22,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: SparkColors.amber.withOpacity(0.7),
                fontSize: 10,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
