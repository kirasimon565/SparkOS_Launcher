import 'app_model.dart';

class FolderModel {
  final String id;
  final String name;
  final List<AppModel> contents;

  FolderModel({
    required this.id,
    required this.name,
    this.contents = const [],
  });
}
