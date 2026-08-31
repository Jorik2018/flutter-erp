import 'package:flutter/material.dart';

class CheckBoxListTitle extends StatelessWidget {
  final String label;
  final bool value;
  final Function change;

  CheckBoxListTitle({
    required this.label,
    required this.value,
    required this.change,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Checkbox(
            value: value,
            onChanged: (newValue) {
              change(newValue);
            },
          ),
        ],
      ),
    );
  }
}
