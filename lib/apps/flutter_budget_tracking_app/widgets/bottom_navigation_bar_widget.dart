import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:flutter_erp/apps/flutter_budget_tracking_app/common/color_constants.dart';
import 'package:flutter_erp/apps/flutter_budget_tracking_app/screens/budget_screen.dart';
import 'package:flutter_erp/apps/flutter_budget_tracking_app/screens/create_budget_screen.dart';
import 'package:flutter_erp/apps/flutter_budget_tracking_app/screens/daily_screen.dart';
import 'package:flutter_erp/apps/flutter_budget_tracking_app/screens/profile_screen.dart';
import 'package:flutter_erp/apps/flutter_budget_tracking_app/screens/stats_screen.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  @override
  _BottomNavigationBarWidgetState createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  int pageIndex = 0;
  List<Widget> pages = [
    DailyScreen(),
    StatsScreen(),
    BudgetScreen(),
    ProfileScreen(),
    CreatBudgetScreen(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
      bottomNavigationBar: getFooter(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          selectedTab(4);
        },
        child: Icon(Icons.add, size: 25),
        backgroundColor: Colors.pink,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget getBody() {
    return IndexedStack(index: pageIndex, children: pages);
  }

  Widget getFooter() {
    List<IconData> iconItems = [
      LineIcons.calendar,
      LineIcons.barChart,
      LineIcons.wallet,
      LineIcons.user,
    ];

    return AnimatedBottomNavigationBar(
      activeColor: primary,
      splashColor: secondary,
      inactiveColor: Colors.black.withValues(alpha: 0.5),
      icons: iconItems,
      activeIndex: pageIndex,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.softEdge,
      leftCornerRadius: 10,
      iconSize: 25,
      rightCornerRadius: 10,
      onTap: (index) {
        selectedTab(index);
      },
    );
  }

  selectedTab(index) {
    setState(() {
      pageIndex = index;
    });
  }
}
