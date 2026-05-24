import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_erp/apps/flutter_todo/models/filter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_erp/apps/flutter_todo/models/todo.dart';
import 'package:flutter_erp/apps/flutter_todo/widgets/todo/todo_card.dart';
import 'package:flutter_erp/apps/flutter_todo/states/todo_state.dart';
import 'package:flutter_erp/apps/flutter_todo/states/todo_provider.dart';

class TodoListView extends ConsumerWidget {
  const TodoListView({super.key});

  Widget _buildEmptyText(Filter filter) {
    final String emptyText;

    switch (filter) {
      case Filter.All:
        emptyText = 'This is boring here.\nCreate a todo to make it crowd.';
        break;
      case Filter.Done:
        emptyText = 'No done todos yet.';
        break;
      case Filter.NotDone:
        emptyText = 'No pending todos.';
        break;
    }

    return Container(
      color: const Color.fromARGB(16, 0, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/todo_list.svg', width: 200),
          const SizedBox(height: 40),
          Text(
            emptyText,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(TodoState state, WidgetRef ref) {
    return ListView.builder(
      itemCount: state.todos.length,
      itemBuilder: (context, index) {
        final Todo todo = state.todos[index];

        return Dismissible(
          key: Key(todo.id ?? '$index'),
          onDismissed: (_) {
            ref.read(todoProvider.notifier).removeTodo(todo.id!);
          },
          background: Container(color: Colors.red),
          child: TodoCard(todo),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(todoProvider);

    final todos = state.todos;
    final filter = state.filter;

    return todos.isNotEmpty
        ? _buildListView(state, ref)
        : _buildEmptyText(filter);
  }
}
