import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_erp/apps/flutter_todo/states/task_state.dart';
import 'package:flutter_erp/apps/flutter_todo/states/task_notifier.dart';

final taskProvider = NotifierProvider<TaskNotifier, TaskState>(
  TaskNotifier.new,
);
