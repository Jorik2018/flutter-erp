import 'package:flutter_erp/AppShell.dart';
import 'package:flutter_erp/apps/covid/screens/covid_screen.dart';
import 'package:flutter_erp/apps/flutter_chat_demo/GoogleContactScreen.dart';
import 'package:flutter_erp/apps/gettaxi/screens/main_page.dart';
import 'package:flutter_erp/apps/netflix_clone/presentation/screens/on_boarding_screen.dart';
import 'package:flutter_erp/apps/smart_home_dashboard/main.dart';
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

      final bool isAuthenticated = authState.value ?? false;

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
          GoRoute(
            path: '/screen1',
            builder: (context, state) => const Screen1(),
          ),
          GoRoute(
            path: '/screen2',
            builder: (context, state) => const Screen2(),
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
