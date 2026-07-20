// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_erp/apps/singtaxi/screens/authenticate/LoginPage.dart';
import 'package:flutter_erp/apps/singtaxi/route_generator.dart';
import 'package:flutter_erp/apps/singtaxi/StartPage.dart';
import 'package:flutter_erp/apps/singtaxi/screens/wrapper.dart';
import 'package:flutter_erp/apps/singtaxi/services/auth.dart';
import 'route_generator.dart';
import 'package:provider/provider.dart';
import 'package:flutter_erp/apps/singtaxi/models/user.dart';
import 'package:flutter_erp/apps/singtaxi/payment/provider/card_cvv_provider.dart';
import 'package:flutter_erp/apps/singtaxi/payment/provider/card_name_provider.dart';
import 'package:flutter_erp/apps/singtaxi/payment/provider/card_number_provider.dart';
import 'package:flutter_erp/apps/singtaxi/payment/provider/card_valid_provider.dart';
import 'package:flutter_erp/apps/singtaxi/payment/provider/state_provider.dart';

import 'package:provider/provider.dart';

void main() => runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => StateProvider()),
      ChangeNotifierProvider(create: (context) => CardNumberProvider()),
      ChangeNotifierProvider(create: (context) => CardNameProvider()),
      ChangeNotifierProvider(create: (context) => CardValidProvider()),
      ChangeNotifierProvider(create: (context) => CardCVVProvider()),
    ],
    child: MyApp(),
  ),
);

//route of whole app
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        title: "DouDou",
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
        home: Scaffold(
          /*appBar: AppBar(title: Text("DouDou"),
              backgroundColor: Colors.brown[600],
            ),*/
          body: Wrapper(),
        ),
      ),
    );
  }
}
