import 'package:flutter/material.dart';

class AppModel {
  final String packageName;
  final String name;
  final IconData icon;
  final bool isFavorite;
  final bool hasNotification;
  final bool isHighlighted;
  final double orbitalDistance;

  const AppModel({
    required this.packageName,
    required this.name,
    this.icon = Icons.apps,
    this.isFavorite = false,
    this.hasNotification = false,
    this.isHighlighted = false,
    this.orbitalDistance = 1.0,
  });
}
