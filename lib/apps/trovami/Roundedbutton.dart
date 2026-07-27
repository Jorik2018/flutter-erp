import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  String buttonName;
  final VoidCallback onTap;

  double height;
  double width;
  double bottomMargin;
  double borderWidth;
  Color buttonColor;
  Color? splashcolor;
  Color? highlightColor;

  TextStyle textStyle = TextStyle(
    color: Color.fromRGBO(255, 255, 255, 0.4),
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
  );

  RoundedButton({
    required this.buttonName,
    required this.onTap,
    required this.height,
    required this.bottomMargin,
    required this.borderWidth,
    required this.width,
    required this.buttonColor,
    this.splashcolor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    if (borderWidth != 0.0)
      return (InkWell(
        onTap: onTap,
        child: Container(
          width: width,
          height: height,
          margin: EdgeInsets.only(bottom: bottomMargin),
          alignment: FractionalOffset.center,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: const BorderRadius.all(const Radius.circular(30.0)),
            border: Border.all(
              color: const Color.fromRGBO(221, 221, 221, 1.0),
              width: borderWidth,
            ),
          ),
          child: Text(buttonName, style: textStyle),
        ),
        //splashColor: splashcolor,
        //highlightColor:highlightColor,
      ));
    else
      return (InkWell(
        onTap: onTap,
        child: Container(
          width: width,
          height: height,
          margin: EdgeInsets.only(bottom: bottomMargin),
          alignment: FractionalOffset.center,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: const BorderRadius.all(const Radius.circular(30.0)),
            border: Border.all(color: Colors.black, width: 1.0),
          ),
          child: Text(buttonName, style: textStyle),
        ),
      ));
  }
}
