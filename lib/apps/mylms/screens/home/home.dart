import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/mylms/services/api/course_service.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My LMS")),
      body: const Center(),
    );
  }
}
