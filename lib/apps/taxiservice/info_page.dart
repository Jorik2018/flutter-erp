import 'package:flutter/material.dart';
import 'tariffs_page.dart';

class Info extends StatefulWidget {
  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('Информация')),
      body: ListView(
        padding: EdgeInsets.all(15.0),
        children: <Widget>[
          ListTile(
            title: Text('Тарифы'),
            trailing: Icon(Icons.navigate_next),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Tariffs()),
              );
            },
          ),
          ListTile(
            trailing: Icon(Icons.navigate_next),
            title: Text('о Нас'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
