import 'package:flutter/material.dart';

get darkTheme => ThemeData(
  primarySwatch: Colors.grey,
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(color: Colors.blueGrey),
    labelStyle: TextStyle(color: Colors.white),
  ),
  brightness: Brightness.dark,
  canvasColor: Colors.black,
);
