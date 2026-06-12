import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/apps_service.dart';
import '../../widgets/spark_icon.dart';

class AppDrawerScreen extends ConsumerStatefulWidget {
  const AppDrawerScreen({Key? key}) : super(key: key);

  @override
  _AppDrawerScreenState createState() => _AppDrawerScreenState();
}

class _AppDrawerScreenState extends ConsumerState<AppDrawerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final apps = ref.watch(appsProvider);
    final appsNotifier = ref.read(appsProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search apps...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.search, color: Colors.amber),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: apps.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.amber))
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 24,
                        ),
                        itemCount: apps.length,
                        itemBuilder: (context, index) {
                          final app = apps[index];
                          return SparkIcon(
                            iconBytes: app.iconBytes,
                            label: app.title,
                            onTap: () =>
                                appsNotifier.launchApp(app.packageName),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
