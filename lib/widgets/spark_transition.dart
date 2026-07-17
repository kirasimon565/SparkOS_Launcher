import 'package:flutter/material.dart';
import '../core/animations.dart';
import '../core/colors.dart';

class SparkLaunchTransition extends StatefulWidget {
  final Widget child;
  final bool isLaunching;
  final bool isClosing;
  final Offset? launchOrigin;
  final VoidCallback? onLaunchComplete;
  final VoidCallback? onCloseComplete;

  const SparkLaunchTransition({
    Key? key,
    required this.child,
    this.isLaunching = false,
    this.isClosing = false,
    this.launchOrigin,
    this.onLaunchComplete,
    this.onCloseComplete,
  }) : super(key: key);

  @override
  State<SparkLaunchTransition> createState() => _SparkLaunchTransitionState();
}

class _SparkLaunchTransitionState extends State<SparkLaunchTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onLaunchComplete?.call();
      } else if (status == AnimationStatus.dismissed) {
        widget.onCloseComplete?.call();
      }
    });
  }

  @override
  void didUpdateWidget(SparkLaunchTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLaunching && !oldWidget.isLaunching) _controller.forward();
    if (widget.isClosing && !oldWidget.isClosing) _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final size = MediaQuery.of(context).size;
        final origin = widget.launchOrigin ?? Offset(size.width / 2, size.height / 2);
        
        return Stack(
          children: [
            widget.child,
            if (_controller.value > 0 && _controller.value < 1.0)
              CustomPaint(
                size: size,
                painter: _SparkRingPainter(
                  progress: _controller.value,
                  origin: origin,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _SparkRingPainter extends CustomPainter {
  final double progress;
  final Offset origin;

  _SparkRingPainter({required this.progress, required this.origin});

  @override
  void paint(Canvas canvas, Size size) {
    final maxRadius = size.width * 1.5;
    final currentRadius = maxRadius * progress;
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          SparkColors.amberWhite.withOpacity(0.6 * (1 - progress)),
          SparkColors.amber.withOpacity(0.3 * (1 - progress)),
          Colors.transparent,
        ],
        stops: const [0.0, 0.02, 0.1],
      ).createShader(Rect.fromCircle(center: origin, radius: currentRadius))
      ..blendMode = BlendMode.screen;
    canvas.drawCircle(origin, currentRadius, paint);
  }

  @override
  bool shouldRepaint(covariant _SparkRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class SparkPageRoute<T> extends PageRouteBuilder<T> {
  SparkPageRoute({required Widget page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 300),
        );
}
