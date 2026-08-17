import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/flutter_medical/routes/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_erp/apps/flutter_medical/services/authenticate.dart';
import 'package:flutter_erp/apps/flutter_medical/services/database.dart';

/// App Root
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? userIsLoggedIn;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInPreference().then((value) {
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      title: "Flutter Medical",
      debugShowCheckedModeBanner: false,
      home: userIsLoggedIn != null
          ? userIsLoggedIn!
                ? HomeScreen()
                : Authenticate()
          : Container(child: Center(child: Authenticate())),
    );
  }
}
