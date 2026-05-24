import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/mahmud_portfolio/sections/about/about_section.dart';
import 'package:flutter_erp/apps/mahmud_portfolio/sections/contact/contact_section.dart';
import 'package:flutter_erp/apps/mahmud_portfolio/sections/feedback/feedback_section.dart';
import 'package:flutter_erp/apps/mahmud_portfolio/sections/follow_us/follow_us.dart';
import 'package:flutter_erp/apps/mahmud_portfolio/sections/my_skills/myskills.dart';
import 'package:flutter_erp/apps/mahmud_portfolio/sections/recent_work/recent_work_section.dart';
import 'package:flutter_erp/apps/mahmud_portfolio/sections/service/service_section.dart';
import 'package:flutter_erp/apps/mahmud_portfolio/sections/top_section/top_section.dart';

import 'constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final topSectionKey = GlobalKey();
  final aboutSectionKey = GlobalKey();
  final serviceSectionKey = GlobalKey();
  final recentWorkSectionKey = GlobalKey();
  final feedbackSectionKey = GlobalKey();
  final contactSectionKey = GlobalKey();

  final ScrollController _scrollController = ScrollController();

  void scrollTo(GlobalKey? key) {
    final context = key!.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        alignment: 0.1,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true, // visible siempre (web style)
        interactive: true, // 👈 draggable
        thickness: 6,
        radius: const Radius.circular(10),

        child: ListView(
          controller: _scrollController,
          children: [
            Column(
              children: [
                Container(
                  key: topSectionKey,
                  child: TopSection(
                    gotoSectoinMethods: [
                      () => scrollTo(topSectionKey),
                      () => scrollTo(aboutSectionKey),
                      () => scrollTo(serviceSectionKey),
                      () => scrollTo(recentWorkSectionKey),
                      () => scrollTo(feedbackSectionKey),
                      () => scrollTo(contactSectionKey),
                    ],
                  ),
                ),

                const SizedBox(height: kDefaultPadding * 2),

                Container(
                  key: aboutSectionKey,
                  child: AboutSection(),
                ),

                Container(
                  key: serviceSectionKey,
                  child: ServiceSection(),
                ),

                MySkillsSection(),

                Container(
                  key: recentWorkSectionKey,
                  child: RecentWorkSection(),
                ),

                Container(
                  key: feedbackSectionKey,
                  child: FeedbackSection(),
                ),

                Container(
                  key: contactSectionKey,
                  child: ContactSection(),
                ),

                 FollowSection(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}