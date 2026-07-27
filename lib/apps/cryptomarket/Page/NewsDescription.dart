import '../models/models.dart';
import 'package:flutter/material.dart';

class NewsDescription extends StatelessWidget {
  final News name;

  const NewsDescription(this.name);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text('NewsDescription', style: TextStyle(fontSize: 20.0)),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 5.0),
              height: 250.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage('${name.imageurl}'),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 20.0,
                bottom: 10.0,
                left: 5.0,
                right: 5.0,
              ),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  name.source.toUpperCase(),
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                name.title,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                name.body,
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
