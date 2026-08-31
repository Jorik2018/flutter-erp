import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/flutter_todo/models/task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_erp/apps/flutter_todo/models/priority.dart';
import 'package:flutter_erp/apps/flutter_todo/helpers/message_dialog.dart';
import 'package:flutter_erp/apps/flutter_todo/helpers/confirm_dialog.dart';
import 'package:flutter_erp/apps/flutter_todo/widgets/ui_elements/loading_modal.dart';
import 'package:flutter_erp/apps/flutter_todo/widgets/form_fields/priority_form_field.dart';
import 'package:flutter_erp/apps/flutter_todo/widgets/form_fields/toggle_form_field.dart';
import 'package:flutter_erp/apps/flutter_todo/states/auth_provider.dart';
import 'package:flutter_erp/apps/flutter_todo/states/task_provider.dart';
import 'package:flutter_erp/apps/flutter_todo/states/task_state.dart';
import 'package:intl/intl.dart';

//okfinal
class TaskEditorPage extends ConsumerStatefulWidget {
  final Task? task;

  const TaskEditorPage({super.key, this.task});

  @override
  ConsumerState<TaskEditorPage> createState() => _TodoEditorPageState();
}

class _TodoEditorPageState extends ConsumerState<TaskEditorPage> {
  _submit() {
    print('99999');
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('======');
      print(_formData);
      /*Task task = Task(
        title: _formData['title'],
        date: _date,
        priority: _priority,
      );

      ref.read(taskProvider.notifier).create();*/
      /*if (widget.task == null) {
        // Insert the task to our user's database
        task.status = 0;
        DatabaseHelper.instance.insertTask(task);
      } else {
        // Update the task
        task.id = widget.task!.id;
        task.status = widget.task!.status;
        DatabaseHelper.instance.updateTask(task);
      }
      widget.updateTaskList();
      Navigator.pop(context);*/
    }
  }

  final Map<String, dynamic> _formData = {
    'title': null,
    'content': null,
    'priority': Priority.Low,
    'isDone': false,
  };

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      _date = widget.task!.date!;
    }

    _dateController.text = _dateFormatter.format(_date);
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _dateController = TextEditingController();

  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');

  DateTime _date = DateTime.now();

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

  Widget _buildFloatingActionButton(TaskState state) {
    final notifier = ref.read(taskProvider.notifier);

    return FloatingActionButton(
      child: const Icon(Icons.save),
      onPressed: () async {
        if (!_formKey.currentState!.validate()) return;

        _formKey.currentState!.save();

        final current = state.currentTask;

        bool success = false;

        if (current != null && current.id != null) {
          success = await notifier.update(
            _formData['title'],
            _formData['content'],
            _formData['priority'],
            _formData['isDone'],
          );
        } else {
          success = await notifier.create(Task.fromMap(_formData));
        }

        if (success) {
          notifier.setCurrent(null);
          if (mounted) Navigator.pop(context);
          print('55555');
        } else {
          MessageDialog.show(context);
        }
      },
    );
  }

  Widget _buildForm(TaskState state) {
    final task = state.currentTask;

    _formData['title'] = task?.title;
    _formData['content'] = task?.content;
    _formData['priority'] = task?.priority ?? Priority.Low;
    _formData['isDone'] = task?.isDone ?? false;

    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          _buildTitleField(task),
          _buildContentField(task),
          const SizedBox(height: 12.0),
          _buildOthers(task),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20.0),
            height: 60.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: TextButton(
              child: Text(
                '', //widget.task == null ? 'Add' : 'Update',
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
              onPressed: _submit,
            ),
          ),
          widget.task != null
              ? Container(
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  height: 60.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: TextButton(
                    child: Text(
                      'Delete',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                    onPressed: _delete,
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildPageContent(TaskState state) {
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
    final todoState = ref.watch(taskProvider);
    final isLoading = todoState.isLoading;

    return Stack(
      children: [_buildPageContent(todoState), if (isLoading) LoadingModal()],
    );
  }

  _delete() {
    /*DatabaseHelper.instance.deleteTask(widget.task!.id!);
    widget.updateTaskList();*/
    Navigator.pop(context);
  }

  Widget _buildTitleField(Task? task) {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Title'),
      initialValue: task != null ? task.title : '',
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

  Widget _buildContentField(Task? task) {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Content'),
      initialValue: task != null ? task.content : '',
      maxLines: 5,
      onSaved: (value) {
        _formData['content'] = value;
      },
    );
  }

  _handleDatePicker() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    /*if (date != null && date != _date) {
      setState(() {
        _date = date;
      });
      _dateController.text = _dateFormatter.format(date);
    }*/
  }

  Widget _buildOthers(Task? todo) {
    final bool isDone = todo?.isDone ?? false;
    final Priority priority = todo?.priority ?? Priority.Low;

    final toggle = ToggleFormField(
      initialValue: isDone,
      onSaved: (bool? value) {
        _formData['isDone'] = value ?? false;
      },
    );

    final date = TextFormField(
      readOnly: true,
      controller: _dateController,
      style: const TextStyle(fontSize: 18.0),
      onTap: _handleDatePicker,
      decoration: InputDecoration(
        labelText: 'Date',
        labelStyle: const TextStyle(fontSize: 18.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );

    final priorityField = PriorityFormField(
      initialValue: priority,
      onSaved: (Priority? value) {
        _formData['priority'] = value ?? Priority.Low;
      },
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isNarrow = constraints.maxWidth < 800;

        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              toggle,

              const SizedBox(height: 16),

              date,

              const SizedBox(height: 16),

              priorityField,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: toggle),

            const SizedBox(width: 12),

            Expanded(child: date),

            const SizedBox(width: 12),

            Expanded(child: priorityField),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }
}
