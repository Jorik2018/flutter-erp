import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_erp/apps/flutter_todo/states/auth_notifier.dart';
import 'package:flutter_erp/apps/flutter_todo/states/auth_state.dart';
import 'package:flutter_erp/apps/flutter_todo/states/theme_notifier.dart';

final authProvider =
    NotifierProvider<AuthNotifier, AuthState?>(AuthNotifier.new);

final themeProvider =
    NotifierProvider<ThemeNotifier, bool>(ThemeNotifier.new);