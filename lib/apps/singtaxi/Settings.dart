import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Setting"),
        backgroundColor: Colors.brown[600],
      ),
      body: Center(
        child: Text(
          "Setting Page",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16.0, color: Colors.black),
        ),
      ),
    );
  }
}
