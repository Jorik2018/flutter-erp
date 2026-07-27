import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_erp/apps/singtaxi/models/profile.dart';
import 'package:flutter_erp/apps/singtaxi/screens/home/profile_tile.dart';

class ProfileList extends StatefulWidget {
  @override
  _ProfilelistState createState() => _ProfilelistState();
}

class _ProfilelistState extends State<ProfileList> {
  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<List<Profile>>(context);

    return ListView.builder(
      itemCount: profile.length,
      itemBuilder: (context, index) {
        return ProfileTile(profile: profile[index]);
      },
    );
    //profile.forEach((Profile){

    //print(Profile.name);
    //  print(Profile.email);

    //return Container();
  }
}
