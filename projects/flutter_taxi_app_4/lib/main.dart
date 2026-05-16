import 'package:flutter/material.dart';
import 'package:taxi_app/Src/app_page.dart';
import 'package:taxi_app/Src/Blocs/auth_bloc.dart';
import 'package:taxi_app/Src/Resource/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);

   runApp(


  
      AppPage(
        new AuthBloc(),
        MaterialApp(
          home: LoginPage(),
        ),
      ),
    );
}