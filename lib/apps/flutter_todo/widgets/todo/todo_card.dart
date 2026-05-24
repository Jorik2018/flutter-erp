import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_erp/apps/flutter_todo/models/todo.dart';
import 'package:flutter_erp/apps/flutter_todo/widgets/helpers/priority_helper.dart';

import 'package:flutter_erp/apps/flutter_todo/states/todo_provider.dart';

class TodoCard extends ConsumerWidget {
  final Todo todo;

  const TodoCard(this.todo, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoNotifier = ref.read(todoProvider.notifier);

    return Card(
      child: Row(
        children: [
          Container(
            width: 40,
            height: 80,
            decoration: BoxDecoration(
              color: PriorityHelper.getPriorityColor(todo.priority),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                bottomLeft: Radius.circular(4),
              ),
            ),
            child: IconButton(
              icon: Icon(
                todo.isDone
                    ? Icons.check
                    : Icons.check_box_outline_blank,
              ),
              onPressed: () {
                todoNotifier.toggleDone(todo.id!);
              },
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                todo.title,
                style: TextStyle(
                  fontSize: 24,
                  decoration: todo.isDone
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ),
          ),

          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              todoNotifier.setCurrentTodo(todo);
              Navigator.pushNamed(context, '/editor');
            },
          ),
        ],
      ),
    );
  }
}