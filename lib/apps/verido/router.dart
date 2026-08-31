import 'dart:ui';

import 'package:flutter_erp/apps/verido/screens/Assignment3.dart';
import 'package:flutter_erp/apps/verido/screens/AssignmentAPI5.dart';
import 'package:flutter_erp/apps/verido/screens/assignment4.dart';
import 'package:flutter_erp/apps/verido/verido_app.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class Configs {
  static String path_parent = '';
}

RouteBase buildRouter({required String path}) {
  Configs.path_parent = path;

  return ShellRoute(
    builder: (context, state, child) {
      return ScreenUtilInit(
        designSize: const Size(400, 810),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, __) => child,
      );
    },
    routes: [
      GoRoute(
        path: path,
        builder: (_, __) => const MyHomePage(),
        routes: [
          GoRoute(path: '/assignment3', builder: (_, __) => Assignment3()),
          GoRoute(path: '/assignment4', builder: (_, __) => Assignment4()),
          GoRoute(path: '/assignment5', builder: (_, __) => Assignment5()),
        ],
      ),
    ],
  );
}
