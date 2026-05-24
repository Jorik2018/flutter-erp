import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_erp/apps/flutter_todo/.env.dart';
import 'package:flutter_erp/apps/flutter_todo/models/filter.dart';
import 'package:flutter_erp/apps/flutter_todo/widgets/helpers/confirm_dialog.dart';
import 'package:flutter_erp/apps/flutter_todo/widgets/ui_elements/loading_modal.dart';
import 'package:flutter_erp/apps/flutter_todo/widgets/todo/todo_list_view.dart';
import 'package:flutter_erp/apps/flutter_todo/widgets/todo/shortcuts_enabled_todo_fab.dart';

import 'package:flutter_erp/apps/flutter_todo/states/auth_provider.dart';
import 'package:flutter_erp/apps/flutter_todo/states/todo_provider.dart';
import 'package:flutter_erp/apps/flutter_todo/states/settings_provider.dart';

class TodoListPage extends ConsumerStatefulWidget {
  const TodoListPage({super.key});

  @override
  ConsumerState<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends ConsumerState<TodoListPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(todoProvider.notifier).fetchTodos();
    });
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
      return const ShortcutsEnabledTodoFab();
    }

    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        ref.read(todoProvider.notifier).setCurrentTodo(null);
        Navigator.pushNamed(context, '/editor');
      },
    );
  }

  Widget _buildBottomBar() {
    final state = ref.watch(todoProvider);
    final notifier = ref.read(todoProvider.notifier);

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
      title: Text(Configure.AppName),
      backgroundColor: Colors.blue,
      actions: [
        IconButton(icon: const Icon(Icons.lock), onPressed: _logout),
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'Settings') {
              Navigator.pushNamed(context, '/settings');
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
    final todoState = ref.watch(todoProvider);

    return Stack(
      children: [
        Scaffold(
          /**The argument type 'Widget' can't be assigned to the parameter type 'PreferredSizeWidget?'. */
          appBar: _buildAppBar(),
          floatingActionButton: _buildFloatingActionButton(),
          bottomNavigationBar: _buildBottomBar(),
          body: const TodoListView(),
        ),

        if (todoState.isLoading) LoadingModal(),
      ],
    );
  }
}
