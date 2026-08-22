import 'package:flutter/material.dart';

class ApplicationThemeProvider {
  static ThemeData get() {
    return ThemeData(
      primaryColorLight: Color(0xff5b626b),
      hintColor: Color(0xffbfc2c5),
      unselectedWidgetColor: Color(0x191a86ff),
      indicatorColor: Color(0x33ffffff),
      highlightColor: Color(0xffe8f2ff),
      disabledColor: Color(0xffffbb76),
      hoverColor: Color(0x19000000),
      fontFamily: 'PlayfairDisplay',
      canvasColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      cardColor: Colors.white,
    );
  }
}
