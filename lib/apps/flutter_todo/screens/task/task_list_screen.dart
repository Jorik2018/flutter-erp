import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/flutter_todo/router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_erp/apps/flutter_todo/models/filter.dart';
import 'package:flutter_erp/apps/flutter_todo/helpers/confirm_dialog.dart';
import 'package:flutter_erp/apps/flutter_todo/widgets/ui_elements/loading_modal.dart';
import 'package:flutter_erp/apps/flutter_todo/widgets/task/task_list_view.dart';
import 'package:flutter_erp/apps/flutter_todo/widgets/task/shortcuts_enabled_task_fab.dart';

import 'package:flutter_erp/apps/flutter_todo/states/auth_provider.dart';
import 'package:flutter_erp/apps/flutter_todo/states/task_provider.dart';
import 'package:flutter_erp/apps/flutter_todo/states/settings_provider.dart';
import 'package:intl/intl.dart';

class TaskListScreen extends ConsumerStatefulWidget {
  const TaskListScreen({super.key});

  @override
  ConsumerState<TaskListScreen> createState() => _TodoListPageState();
}

class _TodoListPageState extends ConsumerState<TaskListScreen> {
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();
  }

  void _logout() async {
    final confirm = await ConfirmDialog.show(context);

    if (confirm!) {
      ref.read(authProvider.notifier).logout();
    }
  }

  Widget _buildFloatingActionButton() {
    final settings = ref.watch(settingsProvider);

    if (settings.isShortcutsEnabled) {
      return const ShortcutsEnabledTaskFab();
    }

    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        ref.read(taskProvider.notifier).setCurrent(null);
        context.push('${Configs.path_parent}/editor');
      },
    );
  }

  Widget _buildBottomBar() {
    final state = ref.watch(taskProvider);
    final notifier = ref.read(taskProvider.notifier);

    Widget buildButton(Filter filter, IconData icon, String label) {
      final selected = state.filter == filter;

      return TextButton(
        onPressed: () => notifier.applyFilter(filter),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: selected ? Colors.white : Colors.black),
            Text(
              label,
              style: TextStyle(color: selected ? Colors.white : Colors.black),
            ),
          ],
        ),
      );
    }

    return BottomAppBar(
      color: Colors.blue,
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildButton(Filter.All, Icons.all_inclusive, 'All'),
          buildButton(Filter.Done, Icons.check, 'Done'),
          buildButton(
            Filter.NotDone,
            Icons.check_box_outline_blank,
            'Not Done',
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text('Configure.AppName'),
      backgroundColor: Colors.blue,
      actions: [
        IconButton(icon: const Icon(Icons.lock), onPressed: _logout),
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'Settings') {
              context.push('${Configs.path_parent}/settings');
            }
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'Settings', child: Text('Settings')),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskState = ref.watch(taskProvider);

    return Stack(
      children: [
        Scaffold(
          appBar: _buildAppBar(),
          floatingActionButton: _buildFloatingActionButton(),
          bottomNavigationBar: _buildBottomBar(),
          body: const TaskListView(),
        ),

        if (taskState.isLoading) LoadingModal(),
      ],
    );
  }
}
