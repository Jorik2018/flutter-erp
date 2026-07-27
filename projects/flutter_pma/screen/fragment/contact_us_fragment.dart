import 'package:flutter/material.dart';

class ContactUsFragment extends StatefulWidget {
  @override
  _ContactUsFragmentState createState() => _ContactUsFragmentState();
}

class _ContactUsFragmentState extends State<ContactUsFragment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child: Center(child: Text("Contact Us Screen"))),
    );
  }
}
