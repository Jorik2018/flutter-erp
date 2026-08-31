import 'package:flutter_erp/apps/flutter_todo/models/task.dart';
import 'package:flutter_erp/apps/flutter_todo/models/filter.dart';
import 'package:equatable/equatable.dart';

class TaskState extends Equatable {
  final List<Task> items;
  final Filter filter;
  final Task? currentTask;
  final bool isLoading;

  const TaskState({
    this.items = const [],
    this.filter = Filter.All,
    this.currentTask,
    this.isLoading = false,
  });

  TaskState copyWith({
    List<Task>? items,
    Filter? filter,
    Task? current,
    bool? isLoading,
  }) {
    return TaskState(
      items: items ?? this.items,
      filter: filter ?? this.filter,
      currentTask: current ?? this.currentTask,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [items, filter, currentTask, isLoading];
}
