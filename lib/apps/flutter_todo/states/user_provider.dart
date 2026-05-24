import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_erp/apps/flutter_todo/states/user_state.dart';
import 'package:flutter_erp/apps/flutter_todo/states/user_notifier.dart';

final userProvider = NotifierProvider<UserNotifier, UserState>(
  UserNotifier.new,
);