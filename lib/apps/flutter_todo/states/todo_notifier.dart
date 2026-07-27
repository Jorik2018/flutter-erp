import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_erp/apps/flutter_todo/widgets/helpers/priority_helper.dart';
import '../models/todo_extensions.dart';
import '../models/todo.dart';
import '../models/filter.dart';
import '../models/priority.dart';
import '../models/user.dart';
import 'todo_state.dart';
import 'package:flutter_erp/apps/flutter_todo/states/auth_provider.dart';

class TodoNotifier extends Notifier<TodoState> {
  User get _user {
    final auth = ref.read(authProvider);

    if (!auth!.isAuthenticated) {
      throw Exception("User not authenticated");
    }

    return auth.user!;
  }

  @override
  TodoState build() {
    // TODO: implement build
    return const TodoState();
  }

  // 🔹 FILTRO (antes applyFilter)
  void applyFilter(Filter filter) {
    state = state.copyWith(filter: filter);
  }

  // 🔹 CURRENT TODO
  void setCurrentTodo(Todo? todo) {
    state = state.copyWith(currentTodo: todo);
  }

  // 🔥 GET FILTERED TODOS (reemplaza getter antiguo)
  List<Todo> get filteredTodos {
    switch (state.filter) {
      case Filter.All:
        return state.todos;
      case Filter.Done:
        return state.todos.where((t) => t.isDone).toList();
      case Filter.NotDone:
        return state.todos.where((t) => !t.isDone).toList();
    }
  }

  // =========================
  // FETCH
  // =========================
  Future<void> fetchTodos() async {
    state = state.copyWith(isLoading: true);

    try {
      final res = await Dio().get(
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
      }

      final List<Todo> loaded = [];

      data.forEach((id, value) {
        loaded.add(
          Todo(
            id: id,
            title: value['title'],
            content: value['content'],
            priority: PriorityHelper.toPriority(value['priority']),
            isDone: value['isDone'],
            userId: _user.id,
          ),
        );
      });

      state = state.copyWith(todos: loaded, isLoading: false);
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  // =========================
  // CREATE
  // =========================
  Future<bool> createTodo(
    String title,
    String content,
    Priority priority,
    bool isDone,
  ) async {
    state = state.copyWith(isLoading: true);

    try {
      final form = {
        'title': title,
        'content': content,
        'priority': priority.toString(),
        'isDone': isDone,
        'userId': _user.id,
      };

      final res = await Dio().post(
        '', //'${Configure.FirebaseUrl}/todos.json?auth=${_user.token}'

        data: json.encode(form),
      );

      if (res.statusCode != 200 && res.statusCode != 201) {
        state = state.copyWith(isLoading: false);
        return false;
      }

      final data = json.decode(res.data);

      final newTodo = Todo(
        id: data['name'],
        title: title,
        content: content,
        priority: priority,
        isDone: isDone,
        userId: _user.id,
      );

      state = state.copyWith(
        todos: [...state.todos, newTodo],
        isLoading: false,
      );

      return true;
    } catch (_) {
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  // =========================
  // UPDATE
  // =========================
  Future<bool> updateTodo(
    String title,
    String content,
    Priority priority,
    bool isDone,
  ) async {
    state = state.copyWith(isLoading: true);

    final current = state.currentTodo;
    if (current == null) return false;

    try {
      final form = {
        'title': title,
        'content': content,
        'priority': priority.toString(),
        'isDone': isDone,
        'userId': _user.id,
      };

      final res = await Dio().put(
        '', //'${Configure.FirebaseUrl}/todos/${current.id}.json?auth=${_user.token}',

        data: json.encode(form),
      );

      if (res.statusCode != 200 && res.statusCode != 201) {
        state = state.copyWith(isLoading: false);
        return false;
      }

      final updated = Todo(
        id: current.id,
        title: title,
        content: content,
        priority: priority,
        isDone: isDone,
        userId: _user.id,
      );

      final list = [...state.todos];
      final index = list.indexWhere((t) => t.id == current.id);

      if (index != -1) {
        list[index] = updated;
      }

      state = state.copyWith(todos: list, currentTodo: null, isLoading: false);

      return true;
    } catch (_) {
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  // =========================
  // DELETE
  // =========================
  Future<bool> removeTodo(String id) async {
    state = state.copyWith(isLoading: true);

    final oldList = [...state.todos];

    final filtered = oldList.where((t) => t.id != id).toList();

    state = state.copyWith(todos: filtered);

    try {
      final res = await Dio().delete(
        '', //'${Configure.FirebaseUrl}/todos/$id.json?auth=${_user.token}'
      );

      if (res.statusCode != 200 && res.statusCode != 201) {
        state = state.copyWith(todos: oldList, isLoading: false);
        return false;
      }

      state = state.copyWith(isLoading: false);
      return true;
    } catch (_) {
      state = state.copyWith(todos: oldList, isLoading: false);
      return false;
    }
  }

  // =========================
  // TOGGLE
  // =========================
  Future<bool> toggleDone(String id) async {
    state = state.copyWith(isLoading: true);

    final list = [...state.todos];
    final todo = list.firstWhere((t) => t.id == id);

    try {
      final form = {
        'title': todo.title,
        'content': todo.content,
        'priority': todo.priority.toString(),
        'isDone': !todo.isDone,
        'userId': _user.id,
      };

      final res = await Dio().put(
        '', //'${Configure.FirebaseUrl}/todos/$id.json?auth=${_user.token}'

        data: json.encode(form),
      );

      if (res.statusCode != 200 && res.statusCode != 201) {
        state = state.copyWith(isLoading: false);
        return false;
      }
      /**The method 'copyWith' isn't defined for the type 'Todo'.
Try correcting the name to the name of an existing method, or defining a method named 'copyWith' */
      final updated = todo.copyWith(isDone: !todo.isDone);

      final index = list.indexWhere((t) => t.id == id);
      list[index] = updated;

      state = state.copyWith(todos: list, isLoading: false);

      return true;
    } catch (_) {
      state = state.copyWith(isLoading: false);
      return false;
    }
  }
}
