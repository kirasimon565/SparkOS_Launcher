import 'widget_model.dart';
import 'app_model.dart';

class PageModel {
  final int pageIndex;
  final List<AppModel> apps;
  final List<WidgetModel> widgets;

  PageModel({
    required this.pageIndex,
    this.apps = const [],
    this.widgets = const [],
  });
}
