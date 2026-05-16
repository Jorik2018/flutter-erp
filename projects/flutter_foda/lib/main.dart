import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foda/services/get_it.dart';
import 'app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:foda/firebase_options.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,).then((_) {
    GetItService.initializeService();
    runApp(const FodaApp());
  });
}