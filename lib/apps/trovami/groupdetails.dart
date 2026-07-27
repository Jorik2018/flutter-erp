import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_erp/apps/trovami/homepage.dart';
import 'package:flutter_erp/apps/trovami/httpClient/httpClient.dart';

import 'InputTextField.dart';
import 'managers/GroupsManager.dart';
import 'core/Group.dart';
import 'core/OldUser.dart';
import 'signinpage.dart';
import 'functionsForFirebaseApiCalls.dart';

//var httpClient = createHttpClient();
// String _selectedChoice="";
var Json = const JsonCodec();
var groupName = "";
Color textFieldColor = const Color.fromRGBO(0, 0, 0, 0.2);
const jsonCodec = const JsonCodec(reviver: _reviver);
const jsonCodec1 = const JsonCodec(reviver: _reviver1);

TextStyle textStyle = TextStyle(
  color: const Color.fromRGBO(0, 0, 0, 0.9),
  fontSize: 16.0,
  fontWeight: FontWeight.normal,
);

ThemeData appTheme = ThemeData(hintColor: Colors.white);

_reviver(key, value) {
  if (key != null && value is Map && key.contains('-')) {
    return OldUser.fromJson(value);
  }
  return value;
}

_reviver1(key, value) {
  if (key != null && value is Map && key.contains('-')) {
    return Group.fromJson(value);
  }
  return value;
}

class AddGroup extends StatefulWidget {
  dynamic? users;

  AddGroup({this.users});

  @override
  AddGroupstate createState() => AddGroupstate(users: users);
}

class AddGroupstate extends State<AddGroup> {
  dynamic? users;

  AddGroupstate({this.users});

  final GlobalKey<ScaffoldState> _scaffoldKeySecondary1 =
      GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _groupformKey = GlobalKey<FormState>();

  bool _autovalidate1 = false;
  List<OldUser> userstoShowGrpDetailsPage = [];
  List<Widget> children1 = [];
  List<OldUser> members = [];
  int count = 0;

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }

  String? checkifnotnull(String? value) {
    if (value != null && value.isEmpty) {
      return 'Groupname must not be empty';
    }
    return null;
  }

  _handleSubmitted() async {
    var httpClient = HttpClientFireBase();
    final FormState? form = _groupformKey!.currentState;
    form!.save();
    OldUser loggedInMember = OldUser();
    loggedInMember.EmailId = loggedinUser;
    loggedInMember.locationShare = false;
    for (var i = 0; i < members.length; i++) {
      GroupsManager().currentGroup().groupmembers!.add(members[i]);
    }
    loggedInMember.name = loggedInUsername;
    GroupsManager().currentGroup().groupmembers!.add(loggedInMember);
    for (
      var i = 0;
      i < GroupsManager().currentGroup().groupmembers!.length;
      i++
    ) {
      users!.value.forEach((k, v) async {
        if (v["emailid"] ==
            GroupsManager().currentGroup().groupmembers![i].EmailId) {
          print("v['groupsIamin'] : ${v["groupsIamin"]}");
          if (v["groupsIamin"] == null) {
            List<String?> groupsIamin = [];
            groupsIamin.add(GroupsManager().currentGroup().groupname!);
            var groupsIaminjson = jsonCodec.encode(groupsIamin);
            await httpClient.put(
              url:
                  'https://trovami-bcd81.firebaseio.com/users/${k}/groupsIamin.json?',
              body: groupsIaminjson,
            );
          } else {
            var response2 = await getUserById(k);

            List resmap = [];
            resmap.addAll(response2.value["groupsIamin"]);
            print("resmap: ${resmap}");

            resmap.add(GroupsManager().currentGroup().groupname);
            var groupsIaminjson = jsonCodec.encode(resmap);
            var response1 = await httpClient.put(
              url:
                  'https://trovami-bcd81.firebaseio.com/users/${k}/groupsIamin.json?',
              body: groupsIaminjson,
            );
          }
        }
      });
    }
    var groupjson = jsonCodec1.encode(GroupsManager().currentGroup());
    var url = "https://trovami-bcd81.firebaseio.com/groups.json";
    await httpClient.post(url: url, body: groupjson);
    Navigator.of(context).pop();
    //      await Navigator.of(context).pushReplacementNamed('/b');
  }

  void _select(OldUser user) {
    members.add(user);
    for (var i = 0; i < userstoShowGrpDetailsPage.length; i++) {
      if (userstoShowGrpDetailsPage[i].EmailId == user.EmailId) {
        userstoShowGrpDetailsPage.removeAt(i);
      }
    }
    setState(() {
      // TODO: Deprecate
      //        popflag=1;
      userstoShowGrpDetailsPage = userstoShowGrpDetailsPage;
      count = count + 1;
    });
  }

  getusers() {
    print('getUsers22');
    users!.value.forEach((k, v) {
      OldUser usertoshow = OldUser();
      usertoshow.name = v["name"];
      usertoshow.EmailId = v["emailid"];
      usertoshow.locationShare = false;
      if (usertoshow.EmailId == loggedinUser) {
      } else {
        userstoShowGrpDetailsPage.add(usertoshow);
      }
    });
  }

  @override
  void initState() => getusers();

  @override
  Widget build(BuildContext context) {
    if (members.isNotEmpty) {
      children1 = List.generate(count, (int i) => memberlist(members[i].name!));
    }

    return Scaffold(
      key: _scaffoldKeySecondary1,
      body: Form(
        //autovalidate: true,
        key: _groupformKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: <Widget>[
            Container(
              child: Container(
                child: Text(
                  "Add a Group",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                padding: const EdgeInsets.only(bottom: 20.0),
              ),
              padding: const EdgeInsets.only(top: 50.0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 0.0, color: Colors.brown[200]!),
                ),
              ),
            ),
            Container(
              child: Container(
                child: InputField(
                  hintText: "Groupname",
                  obscureText: false,
                  textInputType: TextInputType.text,
                  textStyle: textStyle,
                  textFieldColor: textFieldColor,
                  icon: Icons.group,
                  validateFunction: checkifnotnull,
                  iconColor: Colors.grey,
                  bottomMargin: 20.0,
                  onSaved: (String? value) {
                    GroupsManager().currentGroup().groupname = value;
                    GroupsManager().currentGroup().groupmembers = [];
                  },
                ),
                padding: const EdgeInsets.only(
                  bottom: 15.0,
                  top: 0.0,
                  right: 20.0,
                ),
              ),
              padding: const EdgeInsets.only(top: 30.0),
            ),
            Row(
              children: <Widget>[
                Container(
                  child: Text(
                    "Add a member:",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  padding: EdgeInsets.only(left: 13.0),
                ),
                Container(
                  child: CircleAvatar(
                    child: PopupMenuButton<OldUser>(
                      icon: Icon(Icons.add),
                      onSelected: _select,
                      itemBuilder: (BuildContext context) =>
                          userstoShowGrpDetailsPage
                              .map(
                                (OldUser usertoshow) => PopupMenuItem<OldUser>(
                                  value: usertoshow,
                                  child: Text(usertoshow.name!),
                                ),
                              )
                              .toList(),
                    ),
                    backgroundColor: const Color.fromRGBO(0, 0, 0, 0.2),
                  ),
                  padding: const EdgeInsets.only(left: 50.0),
                ),
              ],
            ),
            Column(children: children1),
            Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.bottomCenter,
                  child: FloatingActionButton(
                    onPressed: _handleSubmitted,
                    child: Icon(Icons.check),
                  ),
                  padding: const EdgeInsets.only(top: 50.0, left: 100.0),
                ),
                Container(
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => Homepage(users: users),
                        ),
                      );
                    },
                    child: Icon(Icons.clear),
                    heroTag: null,
                  ),
                  padding: const EdgeInsets.only(top: 50.0, left: 50.0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class memberlist extends StatelessWidget {
  final String mem;
  memberlist(this.mem);

  @override
  Widget build(BuildContext context) => Container(
    child: Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            CircleAvatar(
              child: Icon(Icons.person),
              backgroundColor: const Color.fromRGBO(0, 0, 0, 0.2),
            ),
            Container(
              child: Text("${mem}", style: TextStyle(fontSize: 20.0)),
              padding: EdgeInsets.only(left: 20.0),
            ),
          ],
        ),
      ],
    ),
    padding: EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          width: 0.0,
          color: const Color.fromRGBO(0, 0, 0, 0.2),
        ),
      ),
    ),
  );
}
