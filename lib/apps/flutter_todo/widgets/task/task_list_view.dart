import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/flutter_todo/models/task.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_erp/apps/flutter_todo/models/filter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_erp/apps/flutter_todo/widgets/task/task_card.dart';
import 'package:flutter_erp/apps/flutter_todo/states/task_state.dart';
import 'package:flutter_erp/apps/flutter_todo/states/task_provider.dart';

class TaskListView extends ConsumerWidget {
  const TaskListView({super.key});

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

  Widget _buildListView(TaskState state, WidgetRef ref) {
    return ListView.builder(
      itemCount: state.items.length,
      itemBuilder: (context, index) {
        final Task todo = state.items[index];

        return Dismissible(
          key: Key(todo.id ?? '$index'),
          onDismissed: (_) {
            ref.read(taskProvider.notifier).remove(todo.id!);
          },
          background: Container(color: Colors.red),
          child: TaskCard(todo),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(taskProvider);

    final items = state.items;
    final filter = state.filter;
    /*final int completedTaskCount = snapshot.data!
              .where((Task task) => task.status == 1)
              .toList()
              .length;*/
    return items.isNotEmpty
        ? _buildListView(state, ref)
        : _buildEmptyText(filter);
  }
}
