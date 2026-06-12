import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize this provider in main');
});

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(() {
  return SettingsNotifier();
});

class SettingsState {
  final String activeTheme;
  final bool pageLoopEnabled;
  final int gridColumns;
  final bool hasSeenIntro;

  SettingsState({
    required this.activeTheme,
    required this.pageLoopEnabled,
    required this.gridColumns,
    required this.hasSeenIntro,
  });

  SettingsState copyWith({
    String? activeTheme,
    bool? pageLoopEnabled,
    int? gridColumns,
    bool? hasSeenIntro,
  }) {
    return SettingsState(
      activeTheme: activeTheme ?? this.activeTheme,
      pageLoopEnabled: pageLoopEnabled ?? this.pageLoopEnabled,
      gridColumns: gridColumns ?? this.gridColumns,
      hasSeenIntro: hasSeenIntro ?? this.hasSeenIntro,
    );
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  late SharedPreferences _prefs;

  @override
  SettingsState build() {
    _prefs = ref.watch(sharedPreferencesProvider);
    return SettingsState(
      activeTheme: _prefs.getString('spark_theme_state') ?? 'ember',
      pageLoopEnabled: _prefs.getBool('spark_page_loop') ?? true,
      gridColumns: _prefs.getInt('spark_grid_columns') ?? 4,
      hasSeenIntro: _prefs.getBool('spark_has_seen_intro') ?? false,
    );
  }

  void setTheme(String theme) {
    _prefs.setString('spark_theme_state', theme);
    state = state.copyWith(activeTheme: theme);
  }

  void setHasSeenIntro(bool seen) {
    _prefs.setBool('spark_has_seen_intro', seen);
    state = state.copyWith(hasSeenIntro: seen);
  }

  void setGridColumns(int columns) {
    _prefs.setInt('spark_grid_columns', columns);
    state = state.copyWith(gridColumns: columns);
  }

  void setPageLoop(bool enabled) {
    _prefs.setBool('spark_page_loop', enabled);
    state = state.copyWith(pageLoopEnabled: enabled);
  }
}
