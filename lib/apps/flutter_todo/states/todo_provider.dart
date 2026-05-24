import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_erp/apps/flutter_todo/states/todo_state.dart';
import 'package:flutter_erp/apps/flutter_todo/states/todo_notifier.dart';

final todoProvider =
    NotifierProvider<TodoNotifier, TodoState>(TodoNotifier.new);
