import 'dart:typed_data';

class AppModel {
  final String title;
  final String packageName;
  final Uint8List? iconBytes;
  final String category;

  AppModel({
    required this.title,
    required this.packageName,
    this.iconBytes,
    required this.category,
  });
}
