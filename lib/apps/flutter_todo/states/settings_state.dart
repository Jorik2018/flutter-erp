class SettingsState {
  final bool isShortcutsEnabled;
  final bool isDarkThemeUsed;
  final bool isLoading;

  const SettingsState({
    this.isShortcutsEnabled = false,
    this.isDarkThemeUsed = false,
    this.isLoading = false,
  });

  SettingsState copyWith({
    bool? isShortcutsEnabled,
    bool? isDarkThemeUsed,
    bool? isLoading,
  }) {
    return SettingsState(
      isShortcutsEnabled:
          isShortcutsEnabled ?? this.isShortcutsEnabled,
      isDarkThemeUsed:
          isDarkThemeUsed ?? this.isDarkThemeUsed,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}