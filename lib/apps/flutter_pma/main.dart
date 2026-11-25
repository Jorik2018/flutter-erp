import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/flutter_pma/screen/fragment/children_screen.dart';
import 'package:flutter_erp/apps/flutter_pma/screen/home_screen.dart';
//import 'package:flutter_erp/apps/flutter_pma/screen/background_geolocation_screen.dart';
import 'package:flutter_erp/apps/flutter_pma/screen/fragment/map_fragment.dart';
import 'package:flutter_erp/apps/flutter_pma/screen/fragment/about_us_fragment.dart';
import 'package:flutter_erp/apps/flutter_pma/screen/bar_chart.dart';
import 'package:flutter_erp/apps/flutter_pma/screen/fragment/contact_us_fragment.dart';
import 'package:flutter_erp/apps/flutter_pma/screen/oauth_screen.dart';
import 'package:flutter_erp/apps/flutter_pma/screen/fragment/setting_fragment.dart';
import 'package:flutter_erp/apps/flutter_pma/screen/fragment/child_start_fragment.dart';
import 'package:flutter_erp/apps/flutter_pma/screen/fragment/pregnant_women_fragment.dart';
import 'package:flutter_erp/apps/flutter_pma/screen/fragment/profile_fragment.dart';
import 'package:flutter_erp/apps/flutter_pma/screen/fragment/pregnant_woman_fragment.dart';
import 'package:flutter_erp/apps/flutter_pma/screen/fragment/users_fragment.dart';
import 'package:flutter_erp/apps/flutter_pma/screen/fragment/user_fragment.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_erp/apps/flutter_pma/redux.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:redux/redux.dart';
import 'package:flutter_erp/apps/flutter_pma/utils/util.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  var boxApp = await Hive.openBox('app');

  final store = Store<dynamic>(counterReducer, initialState: "");

  usePathUrlStrategy();

  final rootNavigatorKey = GlobalKey<NavigatorState>();

  final shellNavigatorKey = GlobalKey<NavigatorState>();

  LX mm = LX();
  Connectivity().onConnectivityChanged.listen((
    List<ConnectivityResult> results,
  ) {
    print(results);
  });
  final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    redirect: (context, state) async {
      String? token = await boxApp.get('token');
      if (token != null || state.uri.path.startsWith('/oauth')) {
        if (token != null) http2.headers['Authorization'] = 'Bearer $token';
        return null;
      }
      //var q = state.location.split("?");
      final code = state.uri.queryParameters['code'];
      return '/oauth${code != null ? ('?code=$code') : ''}';
    },
    routes: [
      OAuthRouter(),
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) {
          return HomeScreen(child: child, mm: mm);
        },
        routes: [
          GoRoute(
            path: '/',
            name: '/',
            builder: (context, state) {
              return const BarChartSample1();
            },
            routes: <RouteBase>[
              GoRoute(
                path: 'about-us',
                builder: (BuildContext context, GoRouterState state) {
                  return AboutUsFragment();
                },
              ),
              GoRoute(
                path: 'contact-us',
                builder: (BuildContext context, GoRouterState state) {
                  return ContactUsFragment();
                },
              ),
              GoRoute(
                path: 'setting',
                builder: (BuildContext context, GoRouterState state) {
                  return SettingFragment();
                },
              ),
              GoRoute(
                path: 'pregnant-woman',
                builder: (BuildContext context, GoRouterState state) {
                  return PregnantWomenFragment(mm: mm);
                },
              ),
              GoRoute(
                path: 'pregnant-woman/create',
                builder: (BuildContext context, GoRouterState state) {
                  return PregnantWomanFragment(mm: mm);
                },
              ),
              GoRoute(
                path: 'pregnant-woman/:id/edit',
                builder: (BuildContext context, GoRouterState state) {
                  return PregnantWomanFragment(
                    mm: mm,
                    id: state.pathParameters['id'].toString(),
                  );
                },
              ),
              GoRoute(
                path: 'children',
                builder: (BuildContext context, GoRouterState state) {
                  return ChildrenScreen(mm: mm);
                },
              ),
              GoRoute(
                path: 'user',
                builder: (BuildContext context, GoRouterState state) {
                  return UsersFragment(mm: mm);
                },
              ),
              GoRoute(
                path: 'children/create',
                builder: (BuildContext context, GoRouterState state) {
                  return ChildStartFragment(mm: mm);
                },
              ),
              GoRoute(
                path: 'children/:id/edit',
                builder: (BuildContext context, GoRouterState state) {
                  return ChildStartFragment(
                    mm: mm,
                    id: state.pathParameters['id'].toString(),
                  );
                },
              ),
              GoRoute(
                path: 'user/create',
                builder: (BuildContext context, GoRouterState state) {
                  return UserFragment(mm: mm);
                },
              ),
              GoRoute(
                path: 'user/:id/edit',
                builder: (BuildContext context, GoRouterState state) {
                  return UserFragment(
                    mm: mm,
                    id: int.parse(state.pathParameters['id'].toString()),
                  );
                },
              ),
              GoRoute(
                path: 'map',
                builder: (BuildContext context, GoRouterState state) {
                  return MapFragment(mm: mm);
                },
              ),
              GoRoute(
                path: 'map/:lat/:lon',
                builder: (BuildContext context, GoRouterState state) {
                  return MapFragment(
                    mm: mm,
                    options: {
                      'lat': double.parse(state.pathParameters['lat']!),
                      'lon': double.parse(state.pathParameters['lon']!),
                    },
                  );
                },
              ),
              GoRoute(
                path: 'profile',
                builder: (BuildContext context, GoRouterState state) {
                  return ProfileFragment(mm: mm);
                },
              ),
              GoRoute(
                path: 'setting',
                builder: (BuildContext context, GoRouterState state) {
                  return SettingFragment(mm: mm);
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );

  runApp(
    MaterialApp.router(
      debugShowCheckedModeBanner: false,
      //home: HomeScreen(),
      //home: SplashScreen(),
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      title: 'PMA Ancash',
    ),
  );
}
