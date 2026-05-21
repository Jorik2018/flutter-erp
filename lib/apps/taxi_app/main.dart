import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/taxi_app/login_page.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async{
  await Firebase.initializeApp(
    /**Undefined name 'DefaultFirebaseOptions'.
Try correcting the name to one that is defined, or defining the name. */
    //options: DefaultFirebaseOptions.currentPlatform,
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
