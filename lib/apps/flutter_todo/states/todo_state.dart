import 'package:flutter_erp/apps/flutter_todo/models/todo.dart';
import 'package:flutter_erp/apps/flutter_todo/models/filter.dart';
import 'package:equatable/equatable.dart';

class TodoState extends Equatable {
  final List<Todo> todos;
  final Filter filter;
  final Todo? currentTodo;
  final bool isLoading;

  const TodoState({
    this.todos = const [],
    this.filter = Filter.All,
    this.currentTodo,
    this.isLoading = false,
  });

  TodoState copyWith({
    List<Todo>? todos,
    Filter? filter,
    Todo? currentTodo,
    bool? isLoading,
  }) {
    return TodoState(
      todos: todos ?? this.todos,
      filter: filter ?? this.filter,
      currentTodo: currentTodo ?? this.currentTodo,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [todos, filter, currentTodo, isLoading];
}