import 'package:flutter/material.dart';

import 'package:flutter_erp/apps/verido/widgets/Drawer.dart';
import 'package:flutter_erp/apps/verido/Widgets/MyAppBar.dart';
import 'package:flutter_erp/apps/verido/screens/PrimeDetect.dart';

class VeridoApp extends StatelessWidget {
  const VeridoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyHomePage();
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.65,
        child: DrawerWidget(),
      ),
      body: PrimeDetectState(),
    );
  }
}
