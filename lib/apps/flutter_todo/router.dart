import 'package:flutter_erp/apps/flutter_todo/screens/register_page.dart';
import 'package:flutter_erp/apps/flutter_todo/screens/settings_page.dart';
import 'package:flutter_erp/apps/flutter_todo/screens/task/edit.dart';
import 'package:flutter_erp/apps/flutter_todo/screens/task/task_list_screen.dart';
import 'package:go_router/go_router.dart';

class Configs {
  static String path_parent = '';
}

RouteBase buildRouter({required String path}) {
  Configs.path_parent = path;

  return GoRoute(
    path: path,
    builder: (context, state) => TaskListScreen(),
    routes: [
      GoRoute(path: 'editor', builder: (context, state) => TaskEditorPage()),
      GoRoute(path: 'register', builder: (context, state) => RegisterPage()),
      GoRoute(
        path: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );
}
