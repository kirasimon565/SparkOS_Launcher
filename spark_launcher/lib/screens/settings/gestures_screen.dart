import 'package:flutter/material.dart';

class GesturesScreen extends StatelessWidget {
  const GesturesScreen({super.key}) ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Gestures'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        children: const [
          ListTile(
            title: Text('Swipe Down', style: TextStyle(color: Colors.white)),
            subtitle: Text('Search', style: TextStyle(color: Colors.grey)),
            trailing: Icon(Icons.keyboard_arrow_down, color: Colors.amber),
          ),
          ListTile(
            title: Text('Swipe Up', style: TextStyle(color: Colors.white)),
            subtitle: Text('App Drawer', style: TextStyle(color: Colors.grey)),
            trailing: Icon(Icons.keyboard_arrow_up, color: Colors.amber),
          ),
          ListTile(
            title: Text('Double Tap', style: TextStyle(color: Colors.white)),
            subtitle: Text('Lock Screen', style: TextStyle(color: Colors.grey)),
            trailing: Icon(Icons.touch_app, color: Colors.amber),
          ),
        ],
      ),
    );
  }
}
