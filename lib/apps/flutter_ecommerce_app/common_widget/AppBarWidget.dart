import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/flutter_ecommerce_app/components/AppSignIn.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

PreferredSizeWidget appBarWidget(BuildContext context) {
  return AppBar(
    elevation: 0.0,
    centerTitle: true,
    title: Image.asset(
      "assets/images/ic_app_icon.png",
      width: 80,
      height: 40,
    ),
    actions: [
      IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AppSignIn()),
          );
        },
        icon: const FaIcon(FontAwesomeIcons.user), // 👈 FIX aquí también
        color: const Color(0xFF323232),
      ),
    ],
  );
}