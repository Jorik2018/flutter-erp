import 'package:flutter/material.dart';

enum MyThemeKeys { LIGHT, DARK }

class MyThemes {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: Colors.white,
    brightness: Brightness.light,
    iconTheme: IconThemeData(color: Colors.black),
    splashColor: Colors.white,
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: Colors.grey,
    brightness: Brightness.dark,
    iconTheme: IconThemeData(color: Colors.white),
    splashColor: Colors.black,
  );

  static ThemeData getThemeFromKey(MyThemeKeys? themeKey) {
    switch (themeKey) {
      case MyThemeKeys.LIGHT:
        return lightTheme;
      case MyThemeKeys.DARK:
        return darkTheme;
      default:
        return lightTheme;
    }
  }
}
