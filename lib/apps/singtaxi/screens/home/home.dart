import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/singtaxi/services/auth.dart';
import 'package:flutter_erp/apps/singtaxi/services/database.dart';
import 'package:flutter_erp/apps/singtaxi/models/profile.dart';
import 'package:flutter_erp/apps/singtaxi/screens/home/profile_list.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    /**The named parameter 'initialData' is required, but there's no corresponding argument.
Try adding the required argument */
    return StreamProvider<List<Profile>>.value(
      value: DatabaseService().profile,
      initialData: const [],

      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text('Testing home please work'),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.person),
              label: Text('logout'),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
        body: ProfileList(),
        //child: Text('home'),
      ),
    );
  }
}
