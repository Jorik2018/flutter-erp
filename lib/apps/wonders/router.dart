import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_erp/apps/wonders/common_libs.dart';
import 'package:flutter_erp/apps/wonders/ui/app_scaffold.dart';
import 'package:flutter_erp/apps/wonders/ui/common/modals//fullscreen_video_viewer.dart';
import 'package:flutter_erp/apps/wonders/ui/common/modals/fullscreen_maps_viewer.dart';
import 'package:flutter_erp/apps/wonders/ui/screens/artifact/artifact_carousel/artifact_carousel_screen.dart';
import 'package:flutter_erp/apps/wonders/ui/screens/artifact/artifact_details/artifact_details_screen.dart';
import 'package:flutter_erp/apps/wonders/ui/screens/artifact/artifact_search/artifact_search_screen.dart';
import 'package:flutter_erp/apps/wonders/ui/screens/collection/collection_screen.dart';
import 'package:flutter_erp/apps/wonders/ui/screens/home/wonders_home_screen.dart';
import 'package:flutter_erp/apps/wonders/ui/screens/intro/intro_screen.dart';
import 'package:flutter_erp/apps/wonders/ui/screens/timeline/timeline_screen.dart';
import 'package:flutter_erp/apps/wonders/ui/screens/wallpaper_photo/wallpaper_photo_screen.dart';
import 'package:flutter_erp/apps/wonders/ui/screens/wonder_details/wonders_details_screen.dart';

/// Shared paths / urls used across the app
class ScreenPaths {
  static String splash = '/';
  static String intro = '/welcome';
  static String home = '/home';
  static String settings = '/settings';
  static String wonderDetails(WonderType type) => '/wonder/${type.name}';
  static String video(String id) => '/video/$id';
  static String highlights(WonderType type) => '/highlights/${type.name}';
  static String search(WonderType type) => '/search/${type.name}';
  static String artifact(String id) => '/artifact/$id';
  static String collection(String id) => '/collection?id=$id';
  static String maps(WonderType type) => '/maps/${type.name}';
  static String timeline(WonderType? type) =>
      '/timeline?type=${type?.name ?? ''}';
  static String wallpaperPhoto(WonderType type) =>
      '/wallpaperPhoto/${type.name}';
}

/// Routing table, matches string paths to UI Screens
final appRouter = GoRouter(
  redirect: _handleRedirect,
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return WondersAppScaffold(child: child);
      },
      routes: [
        AppRoute(
          ScreenPaths.splash,
          (_) => Container(color: $styles.colors.greyStrong),
        ), // This will be hidden
        AppRoute(ScreenPaths.home, (_) => HomeScreen()),
        AppRoute(ScreenPaths.intro, (_) => IntroScreen()),
        AppRoute('/wonder/:type', (s) {
          return WonderDetailsScreen(
            type: _parseWonderType(s.pathParameters['type']!),
          );
        }, useFade: true),
        AppRoute('/timeline', (s) {
          return TimelineScreen(
            type: _tryParseWonderType(s.uri.queryParameters['type']!),
          );
        }),
        AppRoute('/video/:id', (s) {
          return FullscreenVideoPage(id: s.pathParameters['id']!);
        }),
        AppRoute('/highlights/:type', (s) {
          return ArtifactCarouselScreen(
            type: _parseWonderType(s.pathParameters['type']!),
          );
        }),
        AppRoute('/search/:type', (s) {
          return ArtifactSearchScreen(
            type: _parseWonderType(s.pathParameters['type']!),
          );
        }),
        AppRoute('/artifact/:id', (s) {
          return ArtifactDetailsScreen(artifactId: s.pathParameters['id']!);
        }),
        AppRoute('/collection', (s) {
          return CollectionScreen(fromId: s.uri.queryParameters['id'] ?? '');
        }),
        AppRoute('/maps/:type', (s) {
          return FullscreenMapsViewer(
            type: _parseWonderType(s.pathParameters['type']!),
          );
        }),
        AppRoute('/wallpaperPhoto/:type', (s) {
          return WallpaperPhotoScreen(
            type: _parseWonderType(s.pathParameters['type']!),
          );
        }),
      ],
    ),
  ],
);

/// Custom GoRoute sub-class to make the router declaration easier to read
class AppRoute extends GoRoute {
  AppRoute(
    String path,
    Widget Function(GoRouterState s) builder, {
    List<GoRoute> routes = const [],
    this.useFade = false,
  }) : super(
         path: path,
         routes: routes,
         pageBuilder: (context, state) {
           final pageContent = Scaffold(
             body: builder(state),
             resizeToAvoidBottomInset: false,
           );
           if (useFade) {
             return CustomTransitionPage(
               key: state.pageKey,
               child: pageContent,
               transitionsBuilder:
                   (context, animation, secondaryAnimation, child) {
                     return FadeTransition(opacity: animation, child: child);
                   },
             );
           }
           return CupertinoPage(child: pageContent);
         },
       );
  final bool useFade;
}

FutureOr<String?> _handleRedirect(BuildContext context, GoRouterState state) {
  // Prevent anyone from navigating away from `/` if app is starting up.
  /**error: The getter 'location' isn't defined for the type 'GoRouterState'.
Try importing the library that defines 'location', correcting the name to the name of an existing getter, or defining a getter or field named 'location'. */
  if (!appLogic.isBootstrapComplete &&
      state.uri.toString() != ScreenPaths.splash) {
    return ScreenPaths.splash;
  }
  debugPrint('Navigate to: ${state.uri.toString()}');
  return null; // do nothing
}

WonderType _parseWonderType(String value) =>
    _tryParseWonderType(value) ?? WonderType.chichenItza;

WonderType? _tryParseWonderType(String value) =>
    WonderType.values.asNameMap()[value];
