// lib/screens/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'page_view.dart';
import 'dock.dart';
import 'search_bar.dart';
import '../../widgets/spark_wallpaper.dart';
import '../../core/animations.dart';
import '../../core/colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Home Screen — The living canvas of Spark Launcher
// ─────────────────────────────────────────────────────────────────────────────

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  // ─── State ────────────────────────────────────────────────────────────────

  bool _isSearchVisible = false;
  bool _isDrawerOpen = false;
  bool _isDockOpen = false;
  bool _isOverviewMode = false;

  // ─── Animation Controllers ────────────────────────────────────────────────

  late AnimationController _searchFadeController;
  late AnimationController _dockRevealController;
  late AnimationController _overviewController;

  // ─── Dock Apps ────────────────────────────────────────────────────────────

  final List<DockApp> _dockApps = [
    const DockApp(
      icon: Icon(Icons.phone_rounded, color: Colors.white, size: 24),
      label: 'Phone',
    ),
    const DockApp(
      icon: Icon(Icons.chat_bubble_rounded, color: Colors.white, size: 24),
      label: 'Messages',
    ),
    const DockApp(
      icon: Icon(Icons.explore_rounded, color: Colors.white, size: 24),
      label: 'Browser',
    ),
    const DockApp(
      icon: Icon(Icons.camera_alt_rounded, color: Colors.white, size: 24),
      label: 'Camera',
    ),
  ];

  // ─── Lifecycle ────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();

    // Search bar fade animation
    _searchFadeController = AnimationController(
      vsync: this,
      duration: SparkAnimationDuration.medium,
    );

    // Dock reveal animation
    _dockRevealController = AnimationController(
      vsync: this,
      duration: SparkAnimationDuration.slow,
    );

    // Overview mode animation
    _overviewController = AnimationController(
      vsync: this,
      duration: SparkAnimationDuration.medium,
    );

    // Start dock reveal after a short delay on first load
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        _dockRevealController.forward();
      }
    });
  }

  @override
  void dispose() {
    _searchFadeController.dispose();
    _dockRevealController.dispose();
    _overviewController.dispose();
    super.dispose();
  }

  // ─── Gesture Handlers ─────────────────────────────────────────────────────

  void _handleVerticalDrag(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;

    if (velocity > 300) {
      // Swipe down → open search
      _openSearch();
    } else if (velocity < -300) {
      // Swipe up → open drawer
      _openDrawer();
    }
  }

  void _handleDoubleTap() {
    HapticFeedback.lightImpact();
    _toggleOverview();
  }

  void _handleLongPress() {
    HapticFeedback.mediumImpact();
    _openOverview();
  }

  // ─── Search ───────────────────────────────────────────────────────────────

  void _openSearch() {
    if (_isSearchVisible) return;

    setState(() => _isSearchVisible = true);
    _searchFadeController.forward();
  }

  void _closeSearch() {
    if (!_isSearchVisible) return;

    _searchFadeController.reverse().then((_) {
      if (mounted) {
        setState(() => _isSearchVisible = false);
      }
    });
  }

  void _toggleSearch() {
    if (_isSearchVisible) {
      _closeSearch();
    } else {
      _openSearch();
    }
  }

  // ─── Drawer ───────────────────────────────────────────────────────────────

  void _openDrawer() {
    if (_isDrawerOpen) return;

    setState(() => _isDrawerOpen = true);
    Navigator.pushNamed(context, '/drawer').then((_) {
      if (mounted) {
        setState(() => _isDrawerOpen = false);
      }
    });
  }

  // ─── Overview Mode ────────────────────────────────────────────────────────

  void _toggleOverview() {
    setState(() => _isOverviewMode = !_isOverviewMode);

    if (_isOverviewMode) {
      _overviewController.forward();
    } else {
      _overviewController.reverse();
    }
  }

  void _openOverview() {
    if (_isOverviewMode) return;

    setState(() => _isOverviewMode = true);
    _overviewController.forward();
  }

  void _closeOverview() {
    if (!_isOverviewMode) return;

    _overviewController.reverse().then((_) {
      if (mounted) {
        setState(() => _isOverviewMode = false);
      }
    });
  }

  // ─── Dock Callbacks ───────────────────────────────────────────────────────

  void _onDockStateChanged(bool isOpen) {
    setState(() => _isDockOpen = isOpen);
  }

  void _onDockAppTap(int index) {
    // Spark animation triggers from the dock itself
    // The app launch logic goes here
    debugPrint('Dock app tapped: $_dockApps[index]');

    // Add a subtle haptic
    HapticFeedback.lightImpact();

    // Future: Launch the app with spark transition
  }

  void _onDockAppLongPress(int index) {
    HapticFeedback.mediumImpact();
    // Show context menu (Remove, Edit, App Info)
    _showDockContextMenu(index);
  }

  void _showDockContextMenu(int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(
            color: SparkColors.amber.withOpacity(0.15),
            width: 0.5,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            // App name
            Text(
              _dockApps[index].label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),

            // Options
            _ContextMenuItem(
              icon: Icons.edit_rounded,
              label: 'Change App',
              onTap: () {
                Navigator.pop(context);
                // Open app picker for this dock slot
              },
            ),
            _ContextMenuItem(
              icon: Icons.remove_circle_outline_rounded,
              label: 'Remove from Dock',
              onTap: () {
                Navigator.pop(context);
                // Remove app from dock
              },
            ),
            _ContextMenuItem(
              icon: Icons.info_outline_rounded,
              label: 'App Info',
              onTap: () {
                Navigator.pop(context);
                // Open app info screen
              },
            ),
          ],
        ),
      ),
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          // Detect vertical swipes for search and drawer
          onVerticalDragEnd: _handleVerticalDrag,

          // Double tap for overview
          onDoubleTap: _handleDoubleTap,

          // Long press for overview mode
          onLongPress: _handleLongPress,

          // Tap on empty space to dismiss
          onTap: () {
            if (_isSearchVisible) _closeSearch();
            if (_isOverviewMode) _closeOverview();
          },

          child: Stack(
            fit: StackFit.expand,
            children: [
              // ─── Layer 0: Wallpaper ─────────────────────────────────────
              const SparkWallpaper(),

              // ─── Layer 1: Home Screen Pages ─────────────────────────────
              // Subtle parallax effect when dock is open
              AnimatedPadding(
                duration: SparkAnimationDuration.medium,
                curve: Curves.easeOutCubic,
                padding: EdgeInsets.only(
                  bottom: _isDockOpen ? 80 : 40,
                ),
                child: AnimatedOpacity(
                  duration: SparkAnimationDuration.medium,
                  opacity: _isOverviewMode ? 0.4 : 1.0,
                  child: Transform.scale(
                    scale: _isOverviewMode ? 0.85 : 1.0,
                    child: const SparkPageView(),
                  ),
                ),
              ),

              // ─── Layer 2: Dark gradient overlay at bottom ──────────────
              // Subtle darkness behind the spark to make it pop
              IgnorePointer(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 160,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.5),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ─── Layer 3: Spark Dock ────────────────────────────────────
              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: SparkDock(
                  apps: _dockApps,
                  sparkColor: SparkColors.amber,
                  onAppTap: _onDockAppTap,
                  onAppLongPress: _onDockAppLongPress,
                  onDockStateChanged: _onDockStateChanged,
                ),
              ),
            ),    

              // ─── Layer 4: Search Bar ────────────────────────────────────
              if (_isSearchVisible)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 12,
                  left: 16,
                  right: 16,
                  child: FadeTransition(
                  opacity: _searchFadeController,
                  child: SparkSearchBar(
                    onDismiss: _closeSearch,
                    fadeAnimation: _searchFadeController,
                  ),
                ),

              // ─── Layer 5: Overview Mode ────────────────────────────────
              if (_isOverviewMode)
                _buildOverviewMode(),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Overview Mode ────────────────────────────────────────────────────────

  Widget _buildOverviewMode() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: _closeOverview,
        child: Container(
          color: Colors.black.withOpacity(0.6),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Pages',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 24),
                // Page thumbnails would go here
                // For now, a placeholder
                Container(
                  width: 200,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: SparkColors.amber.withOpacity(0.2),
                    ),
                  ),
                  child: Center(
                    child: CustomPaint(
                      painter: _OverviewSparkPainter(),
                      size: const Size(40, 40),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Context Menu Item
// ─────────────────────────────────────────────────────────────────────────────

class _ContextMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ContextMenuItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: Colors.white70, size: 20),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Overview Spark Painter
// ─────────────────────────────────────────────────────────────────────────────

class _OverviewSparkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = SparkColors.amber.withOpacity(0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawCircle(center, size.width / 3, paint);

    final corePaint = Paint()
      ..color = SparkColors.amber.withOpacity(0.8)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    canvas.drawCircle(center, size.width / 6, corePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
