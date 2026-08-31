import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/flutter_todo/models/task.dart';
import 'package:flutter_erp/apps/flutter_todo/router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_erp/apps/flutter_todo/helpers/priority_helper.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_erp/apps/flutter_todo/states/task_provider.dart';

class TaskCard extends ConsumerWidget {
  final Task task;

  const TaskCard(this.task, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskNotifier = ref.read(taskProvider.notifier);

    return Column(
      children: [
        ListTile(
          title: Text(
            task.title,
            style: TextStyle(
              fontSize: 18.0,
              decoration: task.status == 0
                  ? TextDecoration.none
                  : TextDecoration.lineThrough,
            ),
          ),
          subtitle: Text(
            '', //'${_dateFormatter.format(task.date!)} • ${task.priority}',
            style: TextStyle(
              fontSize: 15.0,
              decoration: task.status == 0
                  ? TextDecoration.none
                  : TextDecoration.lineThrough,
            ),
          ),
          trailing: Checkbox(
            onChanged: (value) {
              //task.status = value! ? 1 : 0;
              //DatabaseHelper.instance.updateTask(task);
            },
            activeColor: Theme.of(context).primaryColor,
            value: task.status == 1 ? true : false,
          ),
        ),
        Divider(),
        Card(
          child: Row(
            children: [
              Container(
                width: 40,
                height: 80,
                decoration: BoxDecoration(
                  color: PriorityHelper.getPriorityColor(task.priority!),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    bottomLeft: Radius.circular(4),
                  ),
                ),
                child: IconButton(
                  icon: Icon(
                    task.isDone ? Icons.check : Icons.check_box_outline_blank,
                  ),
                  onPressed: () {
                    taskNotifier.toggleDone(task.id!);
                  },
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 24,
                      decoration: task.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ),
              ),

              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  taskNotifier.setCurrent(task);
                  context.push('${Configs.path_parent}/editor');
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
