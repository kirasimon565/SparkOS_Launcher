import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/settings_service.dart';
import '../../services/apps_service.dart';
import '../../widgets/spark_icon.dart';
import '../widgets/widget_host.dart';

class SparkPageView extends ConsumerStatefulWidget {
  const SparkPageView({Key? key}) : super(key: key);

  @override
  _SparkPageViewState createState() => _SparkPageViewState();
}

class _SparkPageViewState extends ConsumerState<SparkPageView> {
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    // Start at a high number for infinite scroll illusion if enabled
    _controller = PageController(initialPage: 1000);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final isLoopEnabled = settings.pageLoopEnabled;
    final gridColumns = settings.gridColumns;

    // In a real app, pages would be fetched from a provider managing PageModels.
    // Here we simulate 3 pages with some dummy content structure based on available apps.
    final apps = ref.watch(appsProvider);
    final appsNotifier = ref.read(appsProvider.notifier);

    final int pageCount = 3;

    return PageView.builder(
      controller: _controller,
      itemCount: isLoopEnabled ? null : pageCount,
      itemBuilder: (context, index) {
        final actualIndex = isLoopEnabled ? index % pageCount : index;

        return SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              children: [
                if (actualIndex == 0) ...[
                  const Expanded(flex: 2, child: WidgetHost()),
                  const SizedBox(height: 24),
                ],
                Expanded(
                  flex: actualIndex == 0 ? 3 : 5,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridColumns,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 24,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: apps.length > (actualIndex + 1) * gridColumns * 4
                        ? gridColumns * 4
                        : (apps.isNotEmpty ? (apps.length / 3).floor() : 0),
                    itemBuilder: (context, gridIndex) {
                      if (apps.isEmpty) return const SizedBox.shrink();

                      // Safely select apps for the page simulation
                      final appIndex =
                          (actualIndex * gridColumns * 4 + gridIndex) %
                              apps.length;
                      final app = apps[appIndex];

                      return SparkIcon(
                        iconBytes: app.iconBytes,
                        label: app.title,
                        onTap: () => appsNotifier.launchApp(app.packageName),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
