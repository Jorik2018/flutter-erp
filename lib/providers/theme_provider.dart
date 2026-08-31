import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_erp/apps/flutter_todo/states/theme_notifier.dart';

final themeProvider = NotifierProvider<ThemeNotifier, bool>(ThemeNotifier.new);
