import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/tourism_demo/styles/app_colors.dart';

class AppTheme {
  static ThemeData get theme {
    final originalTextTheme = ThemeData.light().textTheme;
    final IconThemeData originalIconTheme = ThemeData.light().iconTheme;
    //final TextStyle originalBody1 = originalTextTheme.body1;
    var grayNurseColor = Color(
      0xFFEAE9E7,
    ); // <color name="gray_nurse">#EAE9E7</color>
    var lightGrayColor = Color(
      0xFFD6D6D6,
    ); // <color name="light_gray">#D6D6D6</color>
    return ThemeData.light().copyWith(
      brightness: Brightness.light,
      primaryColor: Colors.orangeAccent,
      secondaryHeaderColor: AppColors.slateGrayColor,
      indicatorColor: Colors.yellow,
      hintColor: grayNurseColor,
      scaffoldBackgroundColor: AppColors.solitudeColor,
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: Colors.orangeAccent),
        hintStyle: TextStyle(color: lightGrayColor),
        // border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.yellow, style: BorderStyle.none)),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red, style: BorderStyle.none),
        ),
      ),
      iconTheme: originalIconTheme.copyWith(
        color: AppColors.linkWaterColor,
        size: 18.0,
      ),
    );
  }
}
