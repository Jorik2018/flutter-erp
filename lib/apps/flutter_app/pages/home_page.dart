import 'package:flutter_erp/apps/flutter_app/fragments/booking.dart';
import 'package:flutter_erp/apps/flutter_app/fragments/notification.dart';
import 'package:flutter_erp/apps/flutter_app/fragments/payment.dart';
import 'package:flutter_erp/apps/flutter_app/fragments/promo.dart';
import 'package:flutter_erp/apps/flutter_app/fragments/helpcenter.dart';

import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/flutter_app/fragments/promo_category.dart';
import 'package:flutter_erp/apps/flutter_app/fragments/startrequest.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class HomePage extends StatefulWidget {
  final drawerItems = [
     DrawerItem("Booking", Icons.rss_feed),
     DrawerItem("Notification", Icons.local_pizza),
     DrawerItem("Payment", Icons.info),
     DrawerItem("Coupon", Icons.info),
     DrawerItem("Help Center", Icons.info),
     DrawerItem("Settings", Icons.info),
     DrawerItem("About", Icons.info)
  ];

  @override
  State<StatefulWidget> createState() {
    return  HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos, BuildContext context) {
    switch (pos) {
      case 0:
        return  BookingScreen();
      case 1:
        return  NotificationFragment();
      case 2:
        return  PaymentFragment();
      case 3:
        return  PromoFragment1();
      case 4:
        return  HelpCenter();
      default:
        return  StartRequestScreen();
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add( ListTile(
        leading:  Icon(d.icon),
        title:  Text(d.title),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(i),
      ));
    }

    return  Scaffold(
      appBar:  AppBar(
        elevation: 0.0,
        // here we display the title corresponding to the fragment
        // you can instead choose to have a static title
        title:  Text(widget.drawerItems[_selectedDrawerIndex].title),
      ),
      drawer:  Drawer(
        child:  Column(
          children: <Widget>[
             UserAccountsDrawerHeader(
                accountName:  Text("John Doe"), accountEmail: null),
             Column(children: drawerOptions)
          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex, context),
    );
  }
}
