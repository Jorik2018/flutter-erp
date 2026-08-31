import 'package:flutter_erp/AppShell.dart';
import 'package:flutter_erp/apps/covid/screens/covid_screen.dart';
import 'package:flutter_erp/apps/flutter_chat_demo/GoogleContactScreen.dart';
import 'package:flutter_erp/apps/flutter_todo/router.dart' as task;
import 'package:flutter_erp/apps/gettaxi/screens/main_page.dart';
import 'package:flutter_erp/apps/mylms/screens/app_navigation.dart';
import 'package:flutter_erp/apps/netflix_clone/presentation/screens/on_boarding_screen.dart';
import 'package:flutter_erp/apps/plantly/pages/plants_list/plants_list_page.dart';
import 'package:flutter_erp/apps/shop_app/router.dart' as shop;
import 'package:flutter_erp/apps/smart_home_dashboard/main.dart';
import 'package:flutter_erp/apps/verido/router.dart' as verido;
import 'package:flutter_erp/screens/HomeScreen.dart';
import 'package:flutter_erp/screens/LoginScreen.dart';
import 'package:flutter_erp/screens/car_rental_screen.dart';
import 'package:flutter_erp/states/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',

    redirect: (context, state) {
      final bool isGoingToLogin = state.matchedLocation == '/login';

      // Mientras se comprueba la sesión, no redirigimos.
      if (authState.isLoading) {
        return null;
      }

      final bool isAuthenticated = authState.value != null;

      if (!isAuthenticated && !isGoingToLogin) {
        return '/login';
      }

      if (isAuthenticated && isGoingToLogin) {
        return '/';
      }

      return null;
    },

    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

      ShellRoute(
        builder: (context, state, child) {
          return AppShell(child: child);
        },

        routes: [
          GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
          task.buildRouter(path: '/todo'),
          shop.buildRouter(path: '/shop'),
          GoRoute(
            path: '/screen1',
            builder: (context, state) => const Screen1(),
          ),
          GoRoute(
            path: '/screen2',
            builder: (context, state) => const Screen2(),
          ),
          verido.buildRouter(path: '/verido'),
          GoRoute(
            path: '/lms',
            builder: (context, state) => const LMSAppNavigation(),
          ),

          GoRoute(
            path: '/plantly',
            builder: (context, state) => PlantsListPage(),
          ),
          GoRoute(path: '/gettaxi', builder: (context, state) => GetTaxiPage()),
          GoRoute(
            path: '/smart-home-dashboard',
            builder: (context, state) => const SmartHomeDashboardPage(),
          ),

          GoRoute(
            path: '/flutter_taxi_app_onboarding',
            builder: (context, state) => OnBoardingScreen(),
          ),
          GoRoute(
            path: '/car-rental',
            builder: (context, state) => CarRentalScreen(),
          ),
          GoRoute(path: '/covid', builder: (context, state) => CovidScreen()),

          GoRoute(
            path: '/google-contact/:currentUserId',
            builder: (context, state) {
              final currentUserId = state.pathParameters['currentUserId']!;

              return GoogleContactScreen(currentUserId: currentUserId);
            },
          ),
        ],
      ),
    ],
  );
});
