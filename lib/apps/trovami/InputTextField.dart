import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  IconData icon;
  String hintText;
  TextInputType textInputType;
  Color textFieldColor, iconColor;
  bool obscureText;
  double bottomMargin;
  TextStyle? textStyle, hintStyle;
  Key? key;

  String? Function(String?)? validateFunction;
  void Function(String?)? onSaved;

  InputField({
    this.key,
    required this.hintText,
    required this.obscureText,
    required this.textInputType,
    required this.textFieldColor,
    required this.icon,
    required this.iconColor,
    required this.bottomMargin,
    required this.textStyle,
    this.validateFunction,
    this.onSaved,
    this.hintStyle,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return (new Container(
      margin: EdgeInsets.only(bottom: bottomMargin),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(new Radius.circular(30.0)),
          color: textFieldColor,
        ),
        child: TextFormField(
          style: textStyle,
          key: key,
          obscureText: obscureText,
          //keyboardType: textInputType,
          validator: validateFunction,
          onSaved: onSaved,
          decoration: InputDecoration(
            hintText: hintText,
            //hintStyle: hintStyle,
            icon: Icon(icon, color: Colors.brown[150]),
            //                hideDivider: true,
          ),
        ),
      ),
    ));
  }
}
