import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_erp/apps/flutter_todo/pages/register/register_page.dart';
import 'package:flutter_erp/apps/flutter_todo/pages/settings/settings_page.dart';
import 'package:flutter_erp/apps/flutter_todo/pages/auth/auth_page.dart';
import 'package:flutter_erp/apps/flutter_todo/pages/todo/todo_editor_page.dart';
import 'package:flutter_erp/apps/flutter_todo/pages/todo/todo_list_page.dart';
import 'package:flutter_erp/apps/flutter_todo/states/auth_provider.dart';

void main() async {
  runApp(ProviderScope(child: TodoApp()));
}

class TodoApp extends ConsumerWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /**Undefined name 'authProvider'.
Try correcting the name to one that is defined, or defining the name */
    final auth = ref.watch(authProvider);
    /**Undefined name 'themeProvider'.
Try correcting the name to one that is defined, or defining the name. */
    final isDarkThemeUsed = ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: isDarkThemeUsed ? Brightness.dark : Brightness.light,
      ),
      routes: {
        '/': (context) =>
            auth!.isAuthenticated ?  TodoListPage() :  AuthPage(),
        '/editor': (context) =>
            auth!.isAuthenticated ?  TodoEditorPage() : const AuthPage(),
        '/register': (context) =>
            auth!.isAuthenticated ?  RegisterPage() : const AuthPage(),
        '/settings': (context) =>
            auth!.isAuthenticated ? const SettingsPage() : const AuthPage(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) =>
              auth!.isAuthenticated ? const TodoListPage() : const AuthPage(),
        );
      },
    );
  }
}