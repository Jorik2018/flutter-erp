import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/flutter_stripe_payments/pages/existing-cards.dart';
import 'package:flutter_erp/apps/flutter_stripe_payments/pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Stripe Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      initialRoute: '/home',
      routes: {
        '/home': (_) => const HomePage(),
        '/existing-cards': (_) => const ExistingCardsPage(),
      },
    );
  }
}
