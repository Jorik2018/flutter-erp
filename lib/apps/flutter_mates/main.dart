import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/flutter_mates/ui/friends/friends_list_page.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF850DD),
        ),
      ),
      home:  FriendsListPage(),
    );
  }
}