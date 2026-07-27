import 'package:flutter/material.dart';

class StartPage extends StatefulWidget {
  StartPage({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("android/assets/HomePage.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 550, left: 120),
            child: Column(
              children: <Widget>[
                ElevatedButton(
                  child: Text(
                    'Hello DouDou',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      textBaseline: TextBaseline.alphabetic,
                    ),
                  ),
                  onPressed: () {
                    //route
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
