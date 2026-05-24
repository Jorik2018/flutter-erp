import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:flutter_erp/apps/flutter_web_admin_dashboard/controllers/menu_controller.dart';
import 'package:flutter_erp/apps/flutter_web_admin_dashboard/pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web Admin Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            /**'MenuController' isn't a function.
Try correcting the name to match an existing function, or define a method or function named 'MenuController */
            create: (context) => AppMenuController(),
          ),
        ],
        child: HomePage(),
      ),
    );
  }
}
