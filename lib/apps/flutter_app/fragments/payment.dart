import 'package:flutter/material.dart';

class PaymentFragment extends StatefulWidget {
  static const img =
      "https://flutter.io/tutorials/layout/images/card-flutter-gallery.png";
  static const String routeName = '/payment';

  @override
  Payment createState() => Payment();
}

class Payment extends State<PaymentFragment> {
  ShapeBorder? _shape;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.credit_card, color: Colors.grey),
          title: const Text("Visa credit card"),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.credit_card, color: Colors.grey),
          title: const Text("Master credit card"),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.credit_card, color: Colors.grey),
          title: const Text("Debit credit card"),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.credit_card, color: Colors.grey),
          title: const Text("Electronic money"),
        ),
        Divider(),
      ],
    );
  }
}
