import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_erp/apps/flutter_todo/models/todo.dart';
import 'package:flutter_erp/apps/flutter_todo/models/priority.dart';
import 'package:flutter_erp/apps/flutter_todo/widgets/helpers/message_dialog.dart';
import 'package:flutter_erp/apps/flutter_todo/widgets/helpers/confirm_dialog.dart';
import 'package:flutter_erp/apps/flutter_todo/widgets/ui_elements/loading_modal.dart';
import 'package:flutter_erp/apps/flutter_todo/widgets/form_fields/priority_form_field.dart';
import 'package:flutter_erp/apps/flutter_todo/widgets/form_fields/toggle_form_field.dart';
import 'package:flutter_erp/apps/flutter_todo/states/auth_provider.dart';
import 'package:flutter_erp/apps/flutter_todo/states/todo_provider.dart';
import 'package:flutter_erp/apps/flutter_todo/states/todo_state.dart';

class TodoEditorPage extends ConsumerStatefulWidget {
  const TodoEditorPage({super.key});

  @override
  ConsumerState<TodoEditorPage> createState() => _TodoEditorPageState();
}

class _TodoEditorPageState extends ConsumerState<TodoEditorPage> {
  final Map<String, dynamic> _formData = {
    'title': null,
    'content': null,
    'priority': Priority.Low,
    'isDone': false,
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.blue,
      actions: [
        IconButton(
          icon: const Icon(Icons.lock),
          onPressed: () async {
            final confirm = await ConfirmDialog.show(context);

            if (confirm == true) {
              ref.read(authProvider.notifier).logout();
              if (mounted) Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton(TodoState state) {
    final notifier = ref.read(todoProvider.notifier);

    return FloatingActionButton(
      child: const Icon(Icons.save),
      onPressed: () async {
        if (!_formKey.currentState!.validate()) return;

        _formKey.currentState!.save();

        final current = state.currentTodo;

        bool success = false;

        if (current != null && current.id != null) {
          success = await notifier.updateTodo(
            _formData['title'],
            _formData['content'],
            _formData['priority'],
            _formData['isDone'],
          );
        } else {
          success = await notifier.createTodo(
            _formData['title'],
            _formData['content'],
            _formData['priority'],
            _formData['isDone'],
          );
        }

        if (success) {
          notifier.setCurrentTodo(null);
          if (mounted) Navigator.pop(context);
        } else {
          MessageDialog.show(context);
        }
      },
    );
  }

  Widget _buildForm(TodoState state) {
    final todo = state.currentTodo;

    _formData['title'] = todo?.title;
    _formData['content'] = todo?.content;
    _formData['priority'] = todo?.priority ?? Priority.Low;
    _formData['isDone'] = todo?.isDone ?? false;

    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          _buildTitleField(todo!),
          _buildContentField(todo),
          const SizedBox(height: 12.0),
          _buildOthers(todo),
        ],
      ),
    );
  }

  Widget _buildPageContent(TodoState state) {
    return Scaffold(
      appBar: _buildAppBar(),
      floatingActionButton: _buildFloatingActionButton(state),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(child: _buildForm(state)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final todoState = ref.watch(todoProvider);
    final isLoading = todoState.isLoading;

    return Stack(
      children: [_buildPageContent(todoState), if (isLoading) LoadingModal()],
    );
  }

  Widget _buildTitleField(Todo todo) {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Title'),
      initialValue: todo != null ? todo.title : '',
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter todo\'s title';
        }

        return null;
      },
      onSaved: (value) {
        _formData['title'] = value;
      },
    );
  }

  Widget _buildContentField(Todo todo) {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Content'),
      initialValue: todo != null ? todo.content : '',
      maxLines: 5,
      onSaved: (value) {
        _formData['content'] = value;
      },
    );
  }

  Widget _buildOthers(Todo todo) {
    final bool isDone = todo != null && todo.isDone;
    final Priority priority = todo != null ? todo.priority : Priority.Low;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        ToggleFormField(
          initialValue: isDone,
          onSaved: (bool? value) {
            _formData['isDone'] = value;
          },
        ),
        PriorityFormField(
          initialValue: priority,
          onSaved: (Priority? value) {
            _formData['priority'] = value;
          },
        ),
      ],
    );
  }
}
