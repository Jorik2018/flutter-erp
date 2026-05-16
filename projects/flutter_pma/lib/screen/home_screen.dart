import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pma/screen/fragment/about_us_fragment.dart';
import 'package:flutter_pma/screen/fragment/contact_us_fragment.dart';
import 'package:flutter_pma/screen/fragment/home_fragment.dart';
import 'package:flutter_pma/screen/fragment/setting_fragment.dart';
import 'package:flutter_pma/screen/fragment/child_start_fragment.dart';
import 'package:flutter_pma/screen/fragment/children_screen.dart';
import 'package:flutter_pma/screen/fragment/map_fragment.dart';
import 'package:flutter_pma/utils/util.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class DrawerItem {
  String title;
  String? path;
  IconData icon;
  List? children;
  Function? onPressed;
  DrawerItem(this.title, this.icon, this.path, {this.children, this.onPressed});
}

class HomeScreen extends StatefulWidget {
  String? path;

  LX? mm;

  Store? store;

  Widget? child;

  HomeScreen({this.path, this.store, this.child, this.mm});

  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DrawerItem? _selectedIndex;

  Map o = {};

  List perms = [];

  String? userName = '';

  @override
  void initState() {
    super.initState();
    print('initState home');
    o = {};
    Hive.openBox('app').then((box) {
      setState(() {
        perms = box.get("perms") ?? [];
      });
    });
    widget.mm!.observer = (key, value) {
      print(key);
      Future.delayed(Duration.zero, () {
        setState(() {
          o[key] = value;
        });
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];
    List drawerItems = [
      DrawerItem("Home", Icons.home, "/"),
      DrawerItem("Mi cuenta", Icons.person, "/profile"),
      DrawerItem("Configuración", Icons.settings, "/setting"),
      DrawerItem("Mapa", Icons.map_rounded, "/map"),
      if (perms.contains("REGISTER_PMA")) ...[
        DrawerItem("Seguimiento de Niños", Icons.child_care, "/children"),
        DrawerItem("Seguimiento de Gestantes", Icons.pregnant_woman_rounded,
            "/pregnant-woman")
      ],
      if (perms.contains("ACCESS_USERS")) ...[
        DrawerItem("Usuarios", Icons.people, "/user")
      ],
      new DrawerItem("Cerrar Sesión", Icons.logout, null,
          onPressed: (BuildContext context) {
        Hive.openBox('app').then((boxApp) {
          boxApp.delete('token').then((value) {
            while (context.canPop()) context.pop();
            context.go("/?v=");
          });
        });
      })
    ];

    for (var i = 0; i < drawerItems.length; i++) {
      var d = drawerItems[i];
      drawerOptions.add(new Column(
        children: <Widget>[
          new ListTile(
            leading: new Icon(d.icon, color: Colors.blue),
            title: new Text(d.title,
                style: new TextStyle(
                    color: Colors.blue, fontWeight: FontWeight.bold)),
            selected: d == _selectedIndex,
            onTap: () => _onSelectItem(d, pop: true),
          ),
          new Divider(
            color: Colors.blue,
            height: 2.0,
          )
        ],
      ));
    }
    var child = (widget.child is Scaffold) ? (widget.child as Scaffold) : null;

    return new Scaffold(
        appBar: o['appBar'] == null
            ? new AppBar(
                title: Text(_selectedIndex != null
                    ? _selectedIndex!.title
                    : (o['title'] ?? 'PMA WIÑANTSIK')),
                elevation:
                    defaultTargetPlatform == TargetPlatform.android ? 5.0 : 0.0,
                actions: o['actions'] ?? actions)
            : null,
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountName: new Text(Util.userName),
                accountEmail: new Text(Util.emailId),
                currentAccountPicture: new CircleAvatar(
                    maxRadius: 24.0,
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage("homer.png"),
              
       
                    /*child: new Center(child: new Image.network(
                      Util.profilePic,
                      height: 58.0,
                      width: 58.0,
                    ))*/
                    // backgroundImage: new Image.network(src),
                    ),
              ),
              /*StoreConnector<int, String>(
                  converter: (store) => store.state.toString(),
                  builder: (context, count) {
                    return Text('$count');
                  },
                ),*/
              new Column(children: drawerOptions)
            ],
          ),
        ),
        body: widget.child // _setDrawerItemWidget(_selectedIndex),

        );
  }

  List<Widget> actions = [];

  bool showHeader = true;

  Map? options;

  _onSelectItem(DrawerItem item, {bool pop: false}) {
    if (pop) Navigator.of(context).pop(); // close the drawer
    setState(() {
      _selectedIndex = item;
    });
    if (item.path != null)
      context.go(item.path!);
    else if (item.onPressed != null) item.onPressed!(context);
  }

  @override
  void dispose() {
    print('dispose home');
    super.dispose();
  }
}
