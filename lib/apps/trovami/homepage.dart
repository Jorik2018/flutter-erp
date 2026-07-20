import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/services.dart';

import 'UnitTests.dart';
import 'groupdetails.dart';
import 'helpers/RoutesHelper.dart';
import 'main.dart';
import 'core/Group.dart';
import 'core/OldUser.dart';
import 'signinpage.dart';
import 'functionsForFirebaseApiCalls.dart';

var temp = [];
String pageName = '';
var groupStatusGroupname = '';
double animValue = 0.0;
List<OldUser> membersToShow = [];
List<String> groupNamesToShow = [];
List<Group> groupsToShow = [];
Group grps = new Group();
const jsonCodec2 = const JsonCodec();
List<OldUser> membersToShowHomepage = [];
final groupref = FirebaseDatabase.instance.ref().child('groups');
final usrref = FirebaseDatabase.instance.ref().child('users');
//var _httpClient = createHttpClient();
const _jsonCodec = const JsonCodec(reviver: _reviver);
var reference;

bool _first = true;

_reviver(key, value) {
  if (key != null && value is Map && key.contains('-')) {
    return new OldUser.fromJson(value);
  }
  return value;
}

class Homepagelayout extends StatelessWidget {
  dynamic? users;

  Homepagelayout({this.users});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return new Container(
      child: Homepage(users: users),
      width: screenSize.width,
      height: screenSize.height,
    );
  }
}

class groupBox extends StatelessWidget {
  final DataSnapshot? snapshot;
  final Animation<double>? animation;
  final int? index;

  groupBox({this.snapshot, this.animation, this.index});

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor: CurvedAnimation(parent: animation!, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 16.0, bottom: 16.0),
              child: CircleAvatar(
                child: IconButton(icon: Icon(Icons.group), onPressed: null),
                backgroundColor: const Color.fromRGBO(0, 0, 0, 0.2),
              ),
            ),
            new ElevatedButton(
              onPressed: () {
                groupStatusGroupname = snapshot!.value! as String;
                RoutesHelper.pushRoute(context, ROUTE_GROUP);
              },
              child: Text(snapshot!.value! as String),
            ),
          ],
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1.0,
              color: const Color.fromRGBO(0, 0, 0, 0.2),
            ),
          ),
        ),
      ),
    );
  }
}

class Homepage extends StatefulWidget {
  dynamic? users;
  Homepage({this.users});

  @override
  HomePageState createState() => new HomePageState(users: users);
}

class HomePageState extends State<Homepage> with TickerProviderStateMixin {
  dynamic? users;
  var userkey;

  HomePageState({this.users});

  getgroups() {
    groupsToShow = [];

    users!.value.forEach((k, v) {
      if (v["emailid"] == loggedinUser) {
        userkey = k;
      }
    });

    setState(() {
      reference = usrref.child(userkey).child("groupsIamin");
      _first = true;
    });
  }

  @override
  void initState() => getgroups();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        leading: Container(),
        actions: <Widget>[
          new IconButton(
            icon: Icon(Icons.group_add),
            onPressed: () async {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddGroup(users: users)),
              );
            },
            iconSize: 42.0,
          ),
          new IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              //TODO
              Animation<double> alpha;

              final AnimationController controller = new AnimationController(
                duration: const Duration(milliseconds: 500),
                vsync: this,
              );
              alpha = new Tween(begin: 0.0, end: 255.0).animate(controller)
                ..addListener(() {});
              controller.forward();
            },
            iconSize: 35.0,
          ),
          new IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => handleMoreMenu(),
            iconSize: 35.0,
          ),
        ],
        title: Text('Groups'),
      ),
      body: Column(
        children: <Widget>[
          new Flexible(
            child: ((reference != null)
                ? new FirebaseAnimatedList(
                    query: reference,
                    sort: (a, b) => b.key!.compareTo(a.key as String),
                    padding: EdgeInsets.all(8.0), //new
                    reverse: false,
                    itemBuilder:
                        (
                          _,
                          DataSnapshot snapshot,
                          Animation<double> animation,
                          index,
                        ) {
                          return new groupBox(
                            snapshot: snapshot,
                            animation: animation,
                            index: index,
                          );
                        },
                  )
                : new Container()), //new
          ),
        ],
      ),
    );
  }

  handleMoreMenu() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => UnitTests()));
  }
}
