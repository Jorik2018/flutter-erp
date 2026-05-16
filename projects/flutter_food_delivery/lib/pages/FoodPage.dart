import 'package:flutter/material.dart';
import 'package:flutter_app/animation/ScaleRoute.dart';
import 'package:flutter_app/pages/FoodOrderPage.dart';
import 'package:flutter_app/widgets/BestFoodWidget.dart';
import 'package:flutter_app/widgets/PopularFoodsWidget.dart';
import 'package:flutter_app/widgets/SearchWidget.dart';
import 'package:flutter_app/widgets/TopMenus.dart';

class FoodPage extends StatefulWidget {
  @override
  _FoodPageState createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> with AutomaticKeepAliveClientMixin<FoodPage>  {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: Column(children: <Widget>[
            SearchWidget(),
            TopMenus(),
            PopularFoodsWidget(),
            BestFoodWidget(),
          ]));
  }
  
  @override
  bool get wantKeepAlive => true;

}
