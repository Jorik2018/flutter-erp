import 'package:flutter/material.dart';
import 'package:flutter_app/animation/ScaleRoute.dart';
import 'package:flutter_app/pages/FoodPage.dart';
import 'package:flutter_app/pages/SignInPage.dart';
import 'package:flutter_app/widgets/BestFoodWidget.dart';
import 'package:flutter_app/widgets/BottomNavBarWidget.dart';
import 'package:flutter_app/widgets/PopularFoodsWidget.dart';
import 'package:flutter_app/widgets/SearchWidget.dart';
import 'package:flutter_app/widgets/TopMenus.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child:Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFAFAFA),
          elevation: 0,
          title: Text(
            "What would you like to eat?",
            style: TextStyle(
                color: Color(0xFF3a3737),
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
          //brightness: Brightness.light,
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.notifications_none,
                  color: Color(0xFF3a3737),
                ),
                onPressed: () {Navigator.push(context, ScaleRoute(page: SignInPage()));})
          ],
        ),
        body: TabBarView(children: [ 
          FoodPage(),
          Icon(Icons.directions_car),
          Icon(Icons.directions_transit),
          Icon(Icons.directions_bike),
        ]),
        bottomNavigationBar: /*const TabBar(
              labelColor: Color(0xFFfd5352),
              tabs: [
                Tab(icon: Icon(Icons.directions_car)),
                Tab(icon: Icon(Icons.directions_car)),
                Tab(icon: Icon(Icons.directions_transit)),
                Tab(icon: Icon(Icons.directions_bike),text: 'Account'),
              ],
            ),*/
        
         BottomNavBarWidget(),
      )
    );
  }
}
