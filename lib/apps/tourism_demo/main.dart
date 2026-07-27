import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_erp/apps/tourism_demo/i18n/translations.dart';
import 'package:flutter_erp/apps/tourism_demo/i18n/translations_delegate.dart';
import 'package:flutter_erp/apps/tourism_demo/redux/app/app_state.dart';
import 'package:flutter_erp/apps/tourism_demo/redux/store.dart';
import 'package:flutter_erp/apps/tourism_demo/styles/app_theme.dart';
import 'package:flutter_erp/apps/tourism_demo/ui/main_page.dart';

Future<Null> main() async {
  // ignore: deprecated_member_use
  //  MaterialPageRoute.debugEnableFadingRoutes = true;

  var store = await createStore();

  runApp(TourismApp(store));
}

class TourismApp extends StatefulWidget {
  final Store<AppState> store;

  TourismApp(this.store);

  @override
  _TourismAppState createState() => _TourismAppState();
}

class _TourismAppState extends State<TourismApp>
    with SingleTickerProviderStateMixin {
  Locale? prevLocale;

  late AnimationController fadeController;

  @override
  void initState() {
    fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      debugLabel: 'preview banner',
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: widget.store,
      child: StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        ignoreChange: (store) => prevLocale == store.appLocale,
        builder: (context, appState) {
          if (prevLocale == null) {
            prevLocale = appState.appLocale;
          }
          bool shouldFade = prevLocale != appState.appLocale;
          if (shouldFade) {
            prevLocale = appState.appLocale;
          }
          return Container(
            color: Theme.of(context).colorScheme.background,
            child: FadeTransition(
              child: MaterialApp(
                onGenerateTitle: (BuildContext context) =>
                    Translations.of(context).title,
                theme: AppTheme.theme,
                localizationsDelegates: [
                  const TranslationsDelegate(),
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                locale: appState.appLocale,
                supportedLocales: widget.store.state.supportedLocales,
                home: const MainPage(),
              ),
              opacity: CurvedAnimation(
                parent: fadeController
                  ..reset()
                  ..forward(),
                curve: const Interval(0.0, 1.0, curve: Curves.ease),
              ),
            ),
          );
        },
      ),
    );
  }
}
