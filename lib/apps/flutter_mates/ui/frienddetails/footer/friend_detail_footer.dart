import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/flutter_mates/ui/frienddetails/footer/articles_showcase.dart';
import 'package:flutter_erp/apps/flutter_mates/ui/frienddetails/footer/portfolio_showcase.dart';
import 'package:flutter_erp/apps/flutter_mates/ui/frienddetails/footer/skills_showcase.dart';
import 'package:flutter_erp/apps/flutter_mates/ui/friends/friend.dart';

class FriendShowcase extends StatefulWidget {
  FriendShowcase(this.friend);

  final Friend? friend;

  @override
  _FriendShowcaseState createState() =>  _FriendShowcaseState();
}

class _FriendShowcaseState extends State<FriendShowcase>
    with TickerProviderStateMixin {
  List<Tab>? _tabs;
  List<Widget>? _pages;
  TabController? _controller;

  @override
  void initState() {
    super.initState();
    _tabs = [
       Tab(text: 'Portfolio'),
       Tab(text: 'Skills'),
       Tab(text: 'Articles'),
    ];
    _pages = [
       PortfolioShowcase(),
       SkillsShowcase(),
       ArticlesShowcase(),
    ];
    _controller =  TabController(
      length: _tabs!.length,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(16.0),
      child:  Column(
        children: <Widget>[
           TabBar(
            controller: _controller,
            tabs: _tabs!,
            indicatorColor: Colors.white,
          ),
           SizedBox.fromSize(
            size: const Size.fromHeight(300.0),
            child:  TabBarView(
              controller: _controller,
              children: _pages!,
            ),
          ),
        ],
      ),
    );
  }
}
