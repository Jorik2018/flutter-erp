import 'package:flutter_erp/AppShell.dart';
import 'package:flutter_erp/apps/covid/screens/covid_screen.dart';
import 'package:flutter_erp/screens/HomeScreen.dart';
import 'package:flutter_erp/screens/LoginScreen.dart';
import 'package:flutter_erp/screens/car_rental_screen.dart';
import 'package:flutter_erp/states/auth_state.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authProvider);

  return GoRouter(
    initialLocation: "/",
    redirect: (context, state) {
      final loggingIn = state.uri.toString() == "/login";

      if (!auth && !loggingIn) return "/login";
      if (auth && loggingIn) return "/";

      return null;
    },
    routes: [
      GoRoute(path: "/login", builder: (context, state) => const LoginScreen()),

      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(path: "/", builder: (context, state) => const HomeScreen()),
          GoRoute(
            path: "/screen1",
            builder: (context, state) => const Screen1(),
          ),
          GoRoute(
            path: "/screen2",
            builder: (context, state) => const Screen2(),
          ),
          GoRoute(
            path: "/car-rental",
            builder: (context, state) => CarRentalScreen(),
          ),
          GoRoute(path: "/covid", builder: (context, state) => CovidScreen()),
        ],
      ),
    ],
  );
});
