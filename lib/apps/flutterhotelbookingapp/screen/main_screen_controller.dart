import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_erp/apps/flutterhotelbookingapp/screen/home_screen.dart';
import 'package:flutter_erp/apps/flutterhotelbookingapp/screen/search_screen.dart';
import 'package:flutter_erp/apps/flutterhotelbookingapp/utils/constants.dart';
import 'package:flutter_erp/apps/flutterhotelbookingapp/utils/theme.dart';

class MainScreenController extends StatefulWidget {
  @override
  _MainScreenControllerState createState() => _MainScreenControllerState();
}

class _MainScreenControllerState extends State<MainScreenController>
    with TickerProviderStateMixin {
  late TabController _controller;
  final List<Widget> tabBarScreens = [
    HomeScreen(),
    SearchScreen(),
    SearchScreen(),
    SearchScreen(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TabController(
      length: tabBarScreens.length,
      vsync: this,
      initialIndex: 0,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    final themeData = ApplicationThemeProvider.get();
    return Scaffold(
      backgroundColor: themeData.scaffoldBackgroundColor,
      body: TabBarView(
        controller: _controller,
        children: tabBarScreens,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: TabBar(
        controller: _controller,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: Colors.transparent,
        isScrollable: false,
        tabs: [
          _buildTabIcon("assets/images/icons/ic_home.png", 0, themeData),
          _buildTabIcon("assets/images/icons/ic_search.png", 1, themeData),
          _buildTabIcon("assets/images/icons/ic_favorite.png", 2, themeData),
          _buildTabIcon("assets/images/icons/ic_cart.png", 3, themeData),
        ],
        onTap: (index) {
          setState(() {});
        },
      ),
    );
  }

  Widget _buildTabIcon(String assetName, int index, ThemeData themeData) {
    return Tab(
      icon: Image.asset(
        assetName,
        width: kBottomItemSize,
        height: kBottomItemSize,
      ),
    );
  }
}
