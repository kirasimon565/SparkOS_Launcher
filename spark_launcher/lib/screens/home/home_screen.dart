import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'page_view.dart';
import 'dock.dart';
import 'search_bar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isSearchVisible = false;

  void _toggleSearch() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Placeholder for wallpaper
      body: GestureDetector(
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            _toggleSearch();
          } else if (details.primaryVelocity! < 0) {
            Navigator.pushNamed(context, '/drawer');
          }
        },
        child: Stack(
          children: [
            const SparkPageView(),
            const Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Dock(),
            ),
            if (_isSearchVisible)
              Positioned(
                top: 50,
                left: 20,
                right: 20,
                child: SparkSearchBar(onDismiss: _toggleSearch),
              ),
          ],
        ),
      ),
    );
  }
}
