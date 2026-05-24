import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_erp/apps/flutter_todo/states/settings_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsNotifier extends Notifier<SettingsState> {
  @override
  SettingsState build() {
    _loadSettings();
    return SettingsState(
      isShortcutsEnabled: false,
      isDarkThemeUsed: false,
    );
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final shortcuts = prefs.getBool('isShortcutsEnabled') ?? false;
    final darkTheme = prefs.getBool('isDarkThemeUsed') ?? false;

    state = SettingsState(
      isShortcutsEnabled: shortcuts,
      isDarkThemeUsed: darkTheme,
    );
  }

  Future<void> toggleShortcuts() async {
    final prefs = await SharedPreferences.getInstance();

    final newValue = !state.isShortcutsEnabled;
    await prefs.setBool('isShortcutsEnabled', newValue);

    state = state.copyWith(isShortcutsEnabled: newValue);
  }

  Future<void> toggleDarkTheme() async {
    final prefs = await SharedPreferences.getInstance();

    final newValue = !state.isDarkThemeUsed;
    await prefs.setBool('isDarkThemeUsed', newValue);

    state = state.copyWith(isDarkThemeUsed: newValue);
  }
}