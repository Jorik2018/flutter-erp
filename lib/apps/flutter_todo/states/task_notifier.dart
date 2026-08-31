import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_erp/apps/flutter_todo/helpers/database_helper.dart';
import 'package:flutter_erp/apps/flutter_todo/models/task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/filter.dart';
import '../models/priority.dart';
import 'package:flutter_erp/models/user.dart' as app_user;
import 'task_state.dart';
import 'package:flutter_erp/apps/flutter_todo/states/auth_provider.dart';

class TaskNotifier extends Notifier<TaskState> {
  /*app_user.User get _user {
    final auth = ref.read(authProvider);

    if (!auth!.isAuthenticated) {
      throw Exception("User not authenticated");
    }

    return auth.user!;
  }*/

  @override
  TaskState build() {
    Future.microtask(() {
      if (ref.mounted) {
        print("taskNotifier.build");
        load();
      }
    });

    return const TaskState();
  }

  // =========================
  // CREATE
  // =========================
  Future<bool> create(Task task) async {
    state = state.copyWith(isLoading: true);

    try {
      final form = {
        'title': task.title,
        'content': task.content,
        'priority': task.priority.toString(),
        'isDone': task.isDone,
        //'userId': _user.id,
      };

      await DatabaseHelper.instance.insertTask(task);
      var newTodo = task;

      /*final res = await Dio().post(
        '', //'${Configure.FirebaseUrl}/todos.json?auth=${_user.token}'

        data: json.encode(form),
      );

      if (res.statusCode != 200 && res.statusCode != 201) {
        state = state.copyWith(isLoading: false);
        return false;
      }

      final data = json.decode(res.data);

      final newTodo = Task(
        id: data['name'],
        title: task.title,
        content: task.content,
        priority: task.priority,
        isDone: task.isDone,
        //userId: _user.id!,
      );*/

      state = state.copyWith(
        items: [...state.items, newTodo],
        isLoading: false,
      );

      return true;
    } catch (e, stackTrace) {
      print('Error: $e');
      print(stackTrace);

      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  // =========================
  // FETCH
  // =========================
  Future<void> load() async {
    print('LOAD()');
    state = state.copyWith(isLoading: true);

    try {
      /*final res = await Dio().get(
        '', //'${Configure.FirebaseUrl}/todos.json?auth=${_user.token}&orderBy="userId"&equalTo="${_user.id}"',
      );

      if (res.statusCode != 200 && res.statusCode != 201) {
        state = state.copyWith(isLoading: false);
        return;
      }

      final data = res.data is String
          ? json.decode(res.data)
          : res.data as Map<String, dynamic>?;

      if (data == null) {
        state = state.copyWith(isLoading: false);
        return;
      }*/

      final List<Task> loaded = [];

      List<Task> data = await DatabaseHelper.instance.getTaskList();
      print('2 - STATE: ${data.length}');
      data.forEach((task) {
        loaded.add(task);
      });

      /*data.forEach((id, value) {
        loaded.add(
          Task(
            id: id,
            title: value['title'],
            content: value['content'],
            priority: PriorityHelper.toPriority(value['priority']),
            isDone: value['isDone'],
            userId: _user.id!,
          ),
        );
      });*/

      state = state.copyWith(items: loaded, isLoading: false);
      print('2 - STATE: ${state.items.length}');
    } catch (e, stackTrace) {
      print('LOAD ERROR: $e');
      print(stackTrace);

      if (ref.mounted) {
        state = state.copyWith(isLoading: false);
      }
    }
  }

  // 🔹 FILTRO (antes applyFilter)
  void applyFilter(Filter filter) {
    state = state.copyWith(filter: filter);
  }

  // 🔹 CURRENT TODO
  void setCurrent(Task? task) {
    state = state.copyWith(current: task);
  }

  // 🔥 GET FILTERED TODOS (reemplaza getter antiguo)
  List<Task> get filteredTodos {
    switch (state.filter) {
      case Filter.All:
        return state.items;
      case Filter.Done:
        return state.items.where((t) => t.isDone).toList();
      case Filter.NotDone:
        return state.items.where((t) => !t.isDone).toList();
    }
  }

  // =========================
  // UPDATE
  // =========================
  Future<bool> update(
    String title,
    String content,
    Priority priority,
    bool isDone,
  ) async {
    state = state.copyWith(isLoading: true);

    final current = state.currentTask;
    if (current == null) return false;

    try {
      final form = {
        'title': title,
        'content': content,
        'priority': priority.toString(),
        'isDone': isDone,
        //'userId': _user.id,
      };

      final res = await Dio().put(
        '', //'${Configure.FirebaseUrl}/todos/${current.id}.json?auth=${_user.token}',

        data: json.encode(form),
      );

      if (res.statusCode != 200 && res.statusCode != 201) {
        state = state.copyWith(isLoading: false);
        return false;
      }

      final updated = Task(
        id: current.id,
        title: title,
        content: content,
        priority: priority,
        isDone: isDone,
        //userId: _user.id!,
      );

      final list = [...state.items];
      final index = list.indexWhere((t) => t.id == current.id);

      if (index != -1) {
        list[index] = updated;
      }

      state = state.copyWith(items: list, current: null, isLoading: false);

      return true;
    } catch (_) {
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  // =========================
  // DELETE
  // =========================
  Future<bool> remove(String id) async {
    state = state.copyWith(isLoading: true);

    final oldList = [...state.items];

    final filtered = oldList.where((t) => t.id != id).toList();

    state = state.copyWith(items: filtered);

    try {
      final res = await Dio().delete(
        '', //'${Configure.FirebaseUrl}/todos/$id.json?auth=${_user.token}'
      );

      if (res.statusCode != 200 && res.statusCode != 201) {
        state = state.copyWith(items: oldList, isLoading: false);
        return false;
      }

      state = state.copyWith(isLoading: false);
      return true;
    } catch (_) {
      state = state.copyWith(items: oldList, isLoading: false);
      return false;
    }
  }

  // =========================
  // TOGGLE
  // =========================
  Future<bool> toggleDone(String id) async {
    state = state.copyWith(isLoading: true);

    final list = [...state.items];
    final todo = list.firstWhere((t) => t.id == id);

    try {
      final form = {
        'title': todo.title,
        'content': todo.content,
        'priority': todo.priority.toString(),
        'isDone': !todo.isDone,
        //'userId': _user.id,
      };

      final res = await Dio().put(
        '', //'${Configure.FirebaseUrl}/todos/$id.json?auth=${_user.token}'

        data: json.encode(form),
      );

      if (res.statusCode != 200 && res.statusCode != 201) {
        state = state.copyWith(isLoading: false);
        return false;
      }
      /**The method 'copyWith' isn't defined for the type 'Task'.
Try correcting the name to the name of an existing method, or defining a method named 'copyWith' */
      final updated = todo.copyWith(isDone: !todo.isDone);

      final index = list.indexWhere((t) => t.id == id);
      list[index] = updated;

      state = state.copyWith(items: list, isLoading: false);

      return true;
    } catch (_) {
      state = state.copyWith(isLoading: false);
      return false;
    }
  }
}
