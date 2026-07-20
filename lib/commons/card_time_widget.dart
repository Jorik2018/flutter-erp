import 'package:flutter/material.dart';

Widget cardTimeWidget(double width) {
  return SizedBox(
    height: 150,
    child: Stack(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              height: 150,
              width: width * 0.45,
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text(
                      "10",
                      style: TextStyle(
                          fontSize: 38, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Sunday, May 25",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Time: 10:00",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 150,
              width: width * 0.45,
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text(
                      "11",
                      style: TextStyle(
                          fontSize: 38, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Sunday, Nov 26",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Time: 10:00",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            child: const Icon(
              Icons.arrow_forward,
              size: 28,
              color: Colors.white,
            ),
          ),
        )
      ],
    ),
  );
}