import 'dart:typed_data';

class AppModel {
  final String packageName;
  final String name;
  final Uint8List? iconBytes;
  final bool isFavorite;
  final bool hasNotification;
  final bool isHighlighted;
  final double orbitalDistance;

  const AppModel({
    required this.packageName,
    required this.name,
    this.iconBytes,
    this.isFavorite = false,
    this.hasNotification = false,
    this.isHighlighted = false,
    this.orbitalDistance = 1.0,
  });
}
