import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/fu_uber/core/ProviderModels/CurrentRideCreationModel.dart';
import 'package:flutter_erp/apps/fu_uber/core/ProviderModels/MapModel.dart';
import 'package:flutter_erp/apps/fu_uber/core/ProviderModels/NearbyDriversModel.dart';
import 'package:flutter_erp/apps/fu_uber/core/ProviderModels/PermissionHandlerModel.dart';
import 'package:flutter_erp/apps/fu_uber/core/ProviderModels/RideBookedModel.dart';
import 'package:flutter_erp/apps/fu_uber/core/ProviderModels/UINotifiersModel.dart';
import 'package:flutter_erp/apps/fu_uber/core/ProviderModels/UserDetailsModel.dart';
import 'package:flutter_erp/apps/fu_uber/core/ProviderModels/VerificationModel.dart';
import 'package:flutter_erp/apps/fu_uber/UI/views/LocationPermissionScreen.dart';
import 'package:flutter_erp/apps/fu_uber/UI/views/MainScreen.dart';
import 'package:flutter_erp/apps/fu_uber/UI/views/OnGoingRideScreen.dart';
import 'package:flutter_erp/apps/fu_uber/UI/views/ProfileScreen.dart';
import 'package:flutter_erp/apps/fu_uber/UI/views/SignIn.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class FuUberApp extends StatelessWidget {
  static const String TAG = "MyApp";

  const FuUberApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PermissionHandlerModel>(
          create: (context) => PermissionHandlerModel(),
        ),

        ChangeNotifierProvider<MapModel>(create: (context) => MapModel()),

        ChangeNotifierProxyProvider<MapModel, RideBookedModel>(
          create: (_) => RideBookedModel(),
          update: (_, mapModel, rideBookedModel) {
            rideBookedModel!.originLatLng = mapModel.pickupPosition;
            rideBookedModel.destinationLatLng = mapModel.destinationPosition;
            return rideBookedModel;
          },
        ),

        ChangeNotifierProvider<VerificationModel>(
          create: (context) => VerificationModel(),
        ),
        ChangeNotifierProvider<NearbyDriversModel>(
          create: (context) => NearbyDriversModel(),
        ),
        ChangeNotifierProvider<UserDetailsModel>(
          create: (context) => UserDetailsModel(),
        ),
        ChangeNotifierProvider<CurrentRideCreationModel>(
          create: (context) => CurrentRideCreationModel(),
        ),

        ChangeNotifierProvider<UINotifiersModel>(
          create: (context) => UINotifiersModel(),
        ),
      ],
      child: MaterialApp(
        title: 'Fu_Uber',
        theme: ThemeData(primarySwatch: Colors.blue),
        navigatorKey: navigatorKey,
        initialRoute: '/',
        routes: {
          LocationPermissionScreen.route: (context) =>
              LocationPermissionScreen(),
          MainScreen.route: (context) => MainScreen(),
          SignInPage.route: (context) => SignInPage(),
          ProfileScreen.route: (context) => ProfileScreen(),
          OnGoingRideScreen.route: (context) => OnGoingRideScreen(),
        },
        home: Scaffold(body: LocationPermissionScreen()),
      ),
    );
  }
}
