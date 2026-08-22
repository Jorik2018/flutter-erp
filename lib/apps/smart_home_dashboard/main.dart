import 'package:flutter/material.dart' hide NavigationDestination;
import 'common/common.dart';
import 'constants/app_colors.dart';
import 'constants/assets.dart';
import 'middle_section.dart';
import 'model/navigation_destination.dart';
import 'navigation_rail.dart';
import 'right_section/right_section.dart';
import 'strings.dart';

class SmartHomeDashboardPage extends StatefulWidget {
  const SmartHomeDashboardPage({Key? key}) : super(key: key);

  @override
  _SmartHomeDashboardPageState createState() => _SmartHomeDashboardPageState();
}

class _SmartHomeDashboardPageState extends State<SmartHomeDashboardPage> {
  /**The name 'NavigationDestination' is defined in the libraries 'package:flutter/src/material/navigation_bar.dart (via package:flutter/material.dart)' and 'package:flutter_erp/apps/smart_home_dashboard/model/navigation_destination.dart'.
Try using 'as prefix' for one of the import directives, or hiding the name from all but one of the imports */
  final List<NavigationDestination> destinations = [
    NavigationDestination(
      icon: Assets.homePng,
      isActive: true,
      tooltip: Strings.home,
    ),
    NavigationDestination(icon: Assets.lampPng, tooltip: Strings.lights),
    NavigationDestination(icon: Assets.securityPng, tooltip: Strings.security),
    NavigationDestination(icon: Assets.locationPng, tooltip: Strings.location),
    NavigationDestination(icon: Assets.usersPng, tooltip: Strings.users),
    NavigationDestination(icon: Assets.chartPng, tooltip: Strings.stats),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainFill,
      body: Row(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: 100,
            color: AppColors.mainFill,
            child: MainNavigationRail(
              destinations: destinations,
              onDestinationClick: (index) {
                print('Index $index pressed');
              },
              onLogoutButtonClick: () {
                print('On logout click');
              },
            ),
          ),
          const HorizontalSpacer(space: 32),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width * .6 - 100,
            color: AppColors.mainFill,
            padding: const EdgeInsets.only(top: 16),
            child: const MiddleSection(),
          ),
          Container(
            color: AppColors.mainFill,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width * .4 - 32,
            padding: const EdgeInsets.only(top: 16, left: 16),
            child: const RightSection(),
          ),
        ],
      ),
    );
  }
}
