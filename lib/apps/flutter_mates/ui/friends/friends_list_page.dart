import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_erp/apps/flutter_mates/ui/frienddetails/friend_details_page.dart';
import 'package:flutter_erp/apps/flutter_mates/ui/friends/friend.dart';

class FriendsListPage extends StatefulWidget {
  @override
  _FriendsListPageState createState() => _FriendsListPageState();
}

class _FriendsListPageState extends State<FriendsListPage> {
  List<Friend> _friends = [];

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  Future<void> _loadFriends() async {
    Response response = await Dio().get(
      'https://randomuser.me/api/?results=25',
    );

    setState(() {
      _friends = Friend.allFromResponse(response.data);
    });
  }

  Widget _buildFriendListTile(BuildContext context, int index) {
    var friend = _friends[index];

    return ListTile(
      onTap: () => _navigateToFriendDetails(friend, index),
      leading: Hero(
        tag: index,
        child: CircleAvatar(backgroundImage: NetworkImage(friend.avatar)),
      ),
      title: Text(friend.name),
      subtitle: Text(friend.email),
    );
  }

  void _navigateToFriendDetails(Friend friend, Object avatarTag) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (c) {
          return FriendDetailsPage(friend, avatarTag: avatarTag);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_friends.isEmpty) {
      content = Center(child: CircularProgressIndicator());
    } else {
      content = ListView.builder(
        itemCount: _friends.length,
        itemBuilder: _buildFriendListTile,
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Friends')),
      body: content,
    );
  }
}
