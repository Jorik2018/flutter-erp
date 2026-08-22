import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_erp/apps/flutter_taxi_app_3/bloc/taxi_booking_bloc.dart';
import 'package:flutter_erp/apps/flutter_taxi_app_3/screens/home_screen.dart';

void main() => runApp(
  MultiBlocProvider(
    providers: [
      BlocProvider<TaxiBookingBloc>(create: (context) => TaxiBookingBloc()),
    ],
    child: MyApp(),
  ),
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taxi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.black,
        fontFamily: 'Ubuntu',
        textTheme: TextTheme(
          headlineMedium: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      home: HomeScreen(),
    );
  }
}
