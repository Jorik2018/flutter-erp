import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_erp/apps/flutter_inventary/views/MovementPage/components/user_data.dart';

class MovementPage extends StatelessWidget {
  String title;
  MovementPage(this.title);
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: UserData(),
  );
}
