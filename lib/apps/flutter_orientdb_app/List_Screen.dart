import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/flutter_orientdb_app/Message_screen.dart';
import 'package:flutter_erp/apps/flutter_orientdb_app/UserModel.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class List_data extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new list_data();
  }
}

class list_data extends State<List_data> {
  SharedPreferences? prf;

  String usename = '';
  /**A value of type 'List<dynamic>' can't be assigned to a variable of type 'List<UserModel>'.
Try changing the type of the variable, or casting the right-hand type to 'List<UserModel>'. */
  List<UserModel> useData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUserDAta();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Users'),
          leading: GestureDetector(child: Icon(Icons.arrow_back), onTap: null),
        ),
        body: Container(
          child: useData.length != 0
              ? ListView.builder(
                  itemCount: useData.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    return new GestureDetector(
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Container(
                          child: Card(
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                useData[index].Username!,
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        /**error:The 'child' argument should be last in widget constructor invocations.
Try moving the argument to the end of the argument list.dartsort_child_properties_last
The method 'setString' can't be unconditionally invoked because the receiver can be 'null'.
Try making the call conditional (using '?.') or adding a null check to the target ('!'). */
                        prf!.setString(
                          'reciver_id',
                          useData[index].rid!.replaceAll('#', ''),
                        );
                        prf!.setString('reciver_name', useData[index].Username!);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Message_screen(),
                          ),
                        );
                      },
                    );
                  },
                )
              : new Center(child: Container()),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              useData.clear();
              getUserDAta();
            });
          },
          child: Icon(Icons.refresh),
        ),
      ),
      onWillPop: null,
    );
  }

  getUserDAta() async {
    prf = await SharedPreferences.getInstance();

    usename = prf!.getString('name')!;

    String db_User = 'root';

    String db_Password = 'orientdb';

    var byte = utf8.encode('$db_User:$db_Password');

    var cre = base64.encode(byte);

    var Headers = {
      'Accept-Encoding': 'gzip,deflate',
      'Content-Length': '0',
      'Authorization': 'Basic $cre',
    };

    var postDataurl =
        "http://192.168.1.4:2480/command/chat_db/sql/select from tbl_user/20/*:-1";

    http.Response response = await http.post(
      Uri.parse(postDataurl),
      headers: Headers,
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      var res1 = res['result'] as List;

      for (int i = 0; i < res1.length; i++) {
        if (res1[i]['username'] == usename) {
          prf!
              .setString('sender_id', res1[i]['@rid'])
              .toString()
              .replaceAll('#', '');
          prf!.setString('sender_name', res1[i]['username']);
        } else if (res1[i]['username'] != usename) {
          useData.add(UserModel.fromJson(res1[i]));
        }
      }

      setState(() {
        useData = this.useData;
      });
    } else {
      print('Error');
    }
  }
}
