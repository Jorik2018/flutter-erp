import 'package:flutter/material.dart';
import 'package:flutter_provider/flutter_provider.dart';

import 'pages/home/home_bloc.dart';
import 'pages/home/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sqlite BLoC RxDart ',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        //accentColor: Colors.redAccent,
      ),
      /**The method 'BlocProvider' isn't defined for the type 'MyApp'.
Try correcting the name to the name of an existing method, or defining a method named 'BlocProvider' */
      home: BlocProvider<HomeBloc>(
        initBloc: (context) => HomeBloc(context.get()),
        child: const HomePage(),
      ),
    );
  }
}
