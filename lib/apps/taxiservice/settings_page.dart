import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage> {
  int _selected = 0;
  bool? val;
  bool _callpermissionValue = false;
  Future<bool>? perm;
  DocumentReference clientRefer = FirebaseFirestore.instance
      .collection('data')
      .doc('$clientDocRef');
  void onChanged(int value) {
    setState(() {
      _selected = value;
      if (value == 0) {
        _saveMapTypeLocal(0);
      } else {
        _saveMapTypeLocal(1);
      }
    });
  }

  void _onChanged(bool value) {
    if (value) {
      _savePermissionLocal(true);
      _updateCallPemission(true);
    } else {
      _savePermissionLocal(false);
      _updateCallPemission(false);
    }
  }

  void _getCallPermission() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      if (pref.getBool('callPerm') != null) {
        _callpermissionValue = pref.getBool('callPerm')!;
      } else {
        _callpermissionValue == false;
      }
    });

    print('Call Pemisstion $_callpermissionValue');
  }

  _saveMapTypeLocal(int value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      pref.setInt('mapType', value);
      pref.setInt('mapType', value);
    });
  }

  _getMapTypeLocal() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      if (pref.getInt('mapType') != null) {
        _selected = pref.getInt('mapType')!;
      } else
        _selected == 0;
    });
    print('MAp type $_selected');
  }

  _savePermissionLocal(bool enable) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      pref.setBool('callPerm', enable);
    });
  }

  _updateCallPemission(bool enable) {
    //print('permission is updated');
    Map<String, bool> data = <String, bool>{"disableCall": enable};
    setState(() {
      clientRefer
          .update(data)
          .whenComplete(() {
            print('permission updated to $enable');
          })
          .catchError((e) => print(e));
      print(clientRefer.id);
    });
  }

  @override
  void initState() {
    super.initState();
    _getCallPermission();
    _getMapTypeLocal();
    print('reference' + clientRefer.id);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //_updateCallPemission(_callpermissionValue);
    return Scaffold(
      appBar: AppBar(title: Text('Настройки')),
      body: ListView(
        padding: const EdgeInsets.all(15.0),
        children: <Widget>[
          ListTile(
            title: Text(
              'Тип Карты',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Column(
            children: <Widget>[
              ListTile(
                trailing: Radio(
                  value: 0,
                  groupValue: _selected,
                  onChanged: (value) {
                    onChanged(value!);
                  },
                ),
                title: Text('Карта'),
              ),
              ListTile(
                trailing: Radio(
                  value: 1,
                  groupValue: _selected,
                  onChanged: (value) {
                    onChanged(value!);
                  },
                ),
                title: Text('Гибрид'),
              ),
            ],
          ),
          Divider(height: .1),
          ListTile(
            trailing: Switch(
              value: _callpermissionValue,
              onChanged: (bool value) {
                setState(() {
                  _onChanged(value);
                  print('valeue changed to $value');
                });
              },
              activeThumbImage: AssetImage('assets/active_phone.png'),
              inactiveThumbImage: AssetImage('assets/phone_inactive.png'),
            ),
            title: Text(
              'Не звонить',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
