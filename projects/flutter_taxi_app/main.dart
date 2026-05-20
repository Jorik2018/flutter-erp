import 'package:flutter/material.dart';
import 'package:taxi_app/src/resource/login_page.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async{
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
   runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
