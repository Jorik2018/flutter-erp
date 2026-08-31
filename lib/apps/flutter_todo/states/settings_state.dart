class SettingsState {
  final bool isShortcutsEnabled;
  final bool isDarkThemeUsed;
  final bool isLoading;
  final String parentPath;

  const SettingsState({
    this.isShortcutsEnabled = false,
    this.isDarkThemeUsed = false,
    this.isLoading = false,
    this.parentPath = '',
  });

  SettingsState copyWith({
    bool? isShortcutsEnabled,
    bool? isDarkThemeUsed,
    bool? isLoading,
    String? parentPath,
  }) {
    return SettingsState(
      isShortcutsEnabled: isShortcutsEnabled ?? this.isShortcutsEnabled,
      isDarkThemeUsed: isDarkThemeUsed ?? this.isDarkThemeUsed,
      isLoading: isLoading ?? this.isLoading,
      parentPath: parentPath ?? this.parentPath,
    );
  }
}
