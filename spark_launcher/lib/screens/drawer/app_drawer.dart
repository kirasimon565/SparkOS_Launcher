import 'package:flutter/material.dart';
import '../../models/app_model.dart';
import '../../widgets/spark_icon.dart';
import 'app_search.dart';
import 'category_view.dart';
import '../../services/apps_service.dart';

class AppDrawer extends StatefulWidget {
  final List<AppModel> apps;

  const AppDrawer({
    super.key,
    required this.apps,
  });

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    // Basic filtering logic
    List<AppModel> filteredApps = widget.apps.where((app) {
      bool matchesSearch = app.title.toLowerCase().contains(_searchQuery.toLowerCase());
      bool matchesCategory = _selectedCategory == 'All' || app.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Container(
      color: Colors.black.withValues(alpha: 0.8),
      child: SafeArea(
        child: Column(
          children: [
            AppSearch(
              onSearch: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),
            CategoryView(
              categories: const ['All', 'Social', 'Games', 'Productivity', 'Tools'],
              selectedCategory: _selectedCategory,
              onSelect: (category) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 24,
                ),
                itemCount: filteredApps.length,
                itemBuilder: (context, index) {
                  return SparkIcon(
                    iconBytes: filteredApps[index].iconBytes,
                    label: filteredApps[index].title,
                    onTap: () {
                       AppsService.launchApp(filteredApps[index].packageName);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
