import 'package:flutter/material.dart';
import 'dart:math';
import '../../core/animations.dart';
import '../../core/colors.dart';
import '../../models/app_model.dart';

class NebulaDrawer extends StatefulWidget {
  final List<AppModel> apps;
  final VoidCallback? onClose;
  final Function(AppModel)? onAppLaunch;
  final bool isOpen;

  const NebulaDrawer({
    Key? key,
    required this.apps,
    this.onClose,
    this.onAppLaunch,
    this.isOpen = false,
  }) : super(key: key);

  @override
  State<NebulaDrawer> createState() => _NebulaDrawerState();
}

class _NebulaDrawerState extends State<NebulaDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scatterAnimation;
  
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  List<AppModel> get _filteredApps {
    if (_searchQuery.isEmpty) return widget.apps;
    return widget.apps
        .where((app) =>
            app.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    
    _scatterAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    if (widget.isOpen) _controller.forward();
  }

  @override
  void didUpdateWidget(NebulaDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOpen && !oldWidget.isOpen) {
      _controller.forward();
    } else if (!widget.isOpen && oldWidget.isOpen) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Offset _getAppPosition(int index, Size screenSize) {
    final random = Random(index * 31 + 7);
    final columns = 4;
    final row = index ~/ columns;
    final col = index % columns;
    
    final baseX = screenSize.width / (columns + 1) * (col + 1);
    final baseY = 150.0 + row * 110.0;
    
    final scatterX = (random.nextDouble() - 0.5) * 30 * _scatterAnimation.value;
    final scatterY = (random.nextDouble() - 0.5) * 20 * _scatterAnimation.value;
    
    return Offset(baseX + scatterX, baseY + scatterY);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final filteredApps = _filteredApps;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          color: Colors.black.withOpacity(0.97 * _fadeAnimation.value),
          child: Stack(
            children: [
              // Apps scattered like embers
              Positioned.fill(
                child: CustomPaint(
                  painter: _NebulaBackgroundPainter(
                    progress: _fadeAnimation.value,
                  ),
                ),
              ),
              
              // Scrollable app grid
              Positioned.fill(
                top: 120,
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: filteredApps.length,
                  itemBuilder: (context, index) {
                    final app = filteredApps[index];
                    final position = _getAppPosition(index, screenSize);
                    
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: Transform.translate(
                        offset: Offset(
                          position.dx - screenSize.width / 2,
                          0,
                        ),
                        child: _NebulaAppItem(
                          app: app,
                          scatterProgress: _scatterAnimation.value,
                          onTap: () {
                            widget.onAppLaunch?.call(app);
                          },
                          onLongPress: () {
                            // Add to orbital ring
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Small star at top
              Positioned(
                top: 40,
                left: 0,
                right: 0,
                child: Center(
                  child: Opacity(
                    opacity: _fadeAnimation.value * 0.6,
                    child: CustomPaint(
                      size: const Size(24, 24),
                      painter: _MiniSparkPainter(),
                    ),
                  ),
                ),
              ),
              
              // Search bar
              Positioned(
                top: 75,
                left: 40,
                right: 40,
                child: Opacity(
                  opacity: _fadeAnimation.value,
                  child: _NebulaSearchBar(
                    controller: _searchController,
                    onChanged: (query) {
                      setState(() => _searchQuery = query);
                    },
                    onClear: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  ),
                ),
              ),
              
              // Close hint
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: _fadeAnimation.value * 0.4,
                  child: const Text(
                    'swipe down to close',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFE6A800),
                      fontSize: 11,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NebulaAppItem extends StatelessWidget {
  final AppModel app;
  final double scatterProgress;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const _NebulaAppItem({
    required this.app,
    required this.scatterProgress,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        height: 90,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: SparkColors.amber.withOpacity(0.3),
                  width: 0.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: app.isHighlighted
                        ? SparkColors.amber.withOpacity(0.4)
                        : SparkColors.amber.withOpacity(0.08),
                    blurRadius: app.isHighlighted ? 12 : 4,
                  ),
                ],
              ),
              child: Icon(
                app.icon,
                color: app.isHighlighted
                    ? SparkColors.amber
                    : SparkColors.amber.withOpacity(0.7),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                app.name,
                style: TextStyle(
                  color: app.isHighlighted
                      ? SparkColors.amber
                      : SparkColors.amber.withOpacity(0.6),
                  fontSize: 15,
                  letterSpacing: 0.5,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (app.hasNotification)
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: SparkColors.amber.withOpacity(0.8),
                  boxShadow: [
                    BoxShadow(
                      color: SparkColors.amber.withOpacity(0.5),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NebulaSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final VoidCallback onClear;

  const _NebulaSearchBar({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: SparkColors.amber.withOpacity(0.3),
            width: 0.8,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: SparkColors.amber.withOpacity(0.5),
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: const TextStyle(
                color: Color(0xFFE6A800),
                fontSize: 14,
                letterSpacing: 1.0,
              ),
              cursorColor: SparkColors.amber,
              decoration: const InputDecoration(
                hintText: 'search embers...',
                hintStyle: TextStyle(
                  color: Color(0x33E6A800),
                  fontSize: 14,
                  letterSpacing: 1.0,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
            GestureDetector(
              onTap: onClear,
              child: Icon(
                Icons.close,
                color: SparkColors.amber.withOpacity(0.5),
                size: 16,
              ),
            ),
        ],
      ),
    );
  }
}

class _NebulaBackgroundPainter extends CustomPainter {
  final double progress;

  _NebulaBackgroundPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final random = Random(42);
    final paint = Paint()
      ..color = SparkColors.amber.withOpacity(0.03 * progress);

    // Background ember particles
    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 1.5 + 0.5;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _NebulaBackgroundPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _MiniSparkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = SparkColors.amber.withOpacity(0.5)
      ..style = PaintingStyle.fill;
    
    final path = Path();
    final r = size.width / 2;
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
  bool shouldRepaint(covariant _MiniSparkPainter oldDelegate) => false;
}
