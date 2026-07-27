import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/flutter_pma/utils/util.dart';

class HomeFragment extends StatefulWidget {
  List<String> list = Util.mediaList;

  List<String> listDe = Util.descriptionList;

  @override
  _HomeFragmentState createState() => _HomeFragmentState();
}

class ListItems {
  String title;
  String mediaImage;
  ListItems(this.title, this.mediaImage);
}

class _HomeFragmentState extends State<HomeFragment> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.list.length; i++) {
      var d = widget.list[i];
      var l = "";
      if (widget.listDe[i] != null) {
        l = widget.listDe[i];
      } else {
        //l ="Test data";
      }
      drawerOptions.add(
        Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                Image.network(d),
                Text(
                  l,
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                Divider(height: 2.0),
              ],
            ),
          ],
        ),
      );
    }
    return Scaffold(
      body: Container(
        child: ListView(children: <Widget>[Column(children: drawerOptions)]),
      ),
    );
  }
}
