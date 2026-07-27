import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:map_view/map_view.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:flutter_erp/apps/trovami/model/userModel.dart';
import 'package:flutter_erp/apps/trovami/firebase_options.dart';
import 'Strings.dart';
import 'helpers/RoutesHelper.dart';
import 'signinpage.dart';
import 'package:firebase_core/firebase_core.dart';

final ThemeData kIOSTheme = ThemeData(
  //primarySwatch: Colors.blueGrey,
  //accentColor: Colors.blueGrey,
);

final ThemeData kDefaultTheme = ThemeData(
  //primarySwatch: Colors.blueGrey,
  //accentColor: Colors.blueGrey,
);

void main() =>
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).then((_) {
      runApp(
        ChangeNotifierProvider(
          create: (context) => UserModel(),
          child: MaterialApp(
            title: Strings.appName,
            debugShowCheckedModeBanner: false,
            home: SignInForm(),
            theme: defaultTargetPlatform == TargetPlatform.iOS
                ? kIOSTheme
                : kDefaultTheme,
            onGenerateRoute: RoutesHelper.provideRoute,
            initialRoute: ROUTE_HOME,
          ),
        ),
      );
    });

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({
    required WidgetBuilder builder,
    required RouteSettings settings,
  }) : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // if (settings.isInitialRoute)
    //   return child;
    return FadeTransition(opacity: animation, child: child);
  }
}

class MyCustomRoute1<T> extends MaterialPageRoute<T> {
  MyCustomRoute1({
    required WidgetBuilder builder,
    required RouteSettings settings,
  }) : super(builder: builder, settings: settings);

  @override
  Widget TransitionBuilder(
    BuildContext context,
    Animation<Offset> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // if (settings.isInitialRoute)
    //   return child;
    return SlideTransition(position: animation, child: child);
  }
}
