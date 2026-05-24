import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_erp/apps/flutter_todo/models/user.dart';
import 'package:flutter_erp/apps/flutter_todo/states/settings_state.dart';
import 'package:flutter_erp/apps/flutter_todo/states/settings_notifier.dart';

final settingsProvider =
    NotifierProvider<SettingsNotifier, SettingsState>(
  SettingsNotifier.new,
);