import 'package:flutter/material.dart';
import 'lista_citta.dart';
import 'dart:math';

class ScreenCercaBiglietto extends StatefulWidget {
  @override
  State createState() => ScreenCercaBigliettoState();
}

class ScreenCercaBigliettoState extends State<ScreenCercaBiglietto> {
  int currentStep = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: FractionalOffset.center,
          children: <Widget>[
            Align(
              alignment: FractionalOffset.topRight,
              child: Container(
                margin: EdgeInsets.only(top: 24.0),
                /**The name 'TextButton' isn't a class.
Try correcting the name to match an existing class. */
                child: TextButton(
                  child: Text("CANCEL"),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  alignment: FractionalOffset.center,
                  children: <Widget>[
                    RotatedBox(
                      quarterTurns: 1,
                      child: Icon(
                        Icons.flight,
                        size: 64.0,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox.fromSize(
                      size: Size.fromRadius(48.0),
                      child: CircularProgressIndicator(),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 64.0),
                  child: Text(
                    "3/64" /*, style: Theme.of(context).textTheme.title*/,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 32.0),
                  child: Text("Searching for the lowest plane ticket price..."),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
