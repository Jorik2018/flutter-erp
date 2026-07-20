import 'package:flutter/material.dart';

class SettingFragment extends StatefulWidget {
  @override
  _SettingFragmentState createState() => new _SettingFragmentState();
}

class _SettingFragmentState extends State<SettingFragment> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(child: Center(child: Text("Setting Screen"))),
    );
  }
}
