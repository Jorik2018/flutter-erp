import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/singtaxi/models/user.dart';
import 'package:flutter_erp/apps/singtaxi/payment/provider/card_cvv_provider.dart';
import 'package:flutter_erp/apps/singtaxi/payment/provider/card_name_provider.dart';
import 'package:flutter_erp/apps/singtaxi/payment/provider/card_number_provider.dart';
import 'package:flutter_erp/apps/singtaxi/payment/provider/card_valid_provider.dart';
import 'package:flutter_erp/apps/singtaxi/payment/provider/state_provider.dart';
import 'package:flutter_erp/apps/singtaxi/route_generator.dart';
import 'package:flutter_erp/apps/singtaxi/screens/wrapper.dart';
import 'package:flutter_erp/apps/singtaxi/services/auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StateProvider()),
        ChangeNotifierProvider(create: (_) => CardNumberProvider()),
        ChangeNotifierProvider(create: (_) => CardNameProvider()),
        ChangeNotifierProvider(create: (_) => CardValidProvider()),
        ChangeNotifierProvider(create: (_) => CardCVVProvider()),

        StreamProvider<XUser?>(
          create: (_) => AuthService().user,
          initialData: null,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DouDou',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
      home: Scaffold(body: Wrapper()),
    );
  }
}
