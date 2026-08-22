import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/home/home_bloc.dart';
import 'pages/home/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sqlite BLoC RxDart',
      theme: ThemeData(primarySwatch: Colors.yellow),
      home: Provider<HomeBloc>(
        create: (context) => HomeBloc(context.read()),
        dispose: (_, bloc) => bloc.dispose(),
        child: const HomePage(),
      ),
    );
  }
}
