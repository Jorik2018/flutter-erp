import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_erp/apps/flutter_todo/states/auth_notifier.dart';
import 'package:flutter_erp/apps/flutter_todo/states/auth_state.dart';

final authProvider = NotifierProvider<AuthNotifier, AuthState?>(
  AuthNotifier.new,
);
