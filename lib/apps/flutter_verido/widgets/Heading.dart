import "package:flutter/material.dart";

class Heading extends StatelessWidget {
  final String label;
  Heading({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: Colors.black,
        fontSize: 22,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
