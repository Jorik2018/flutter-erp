import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/openflutterecommerce/config/theme.dart';

import 'bottom_menu.dart';

class OpenFlutterCollapsingScaffold extends StatelessWidget {
  const OpenFlutterCollapsingScaffold({
    super.key,
    this.background,
    this.title,
    required this.body,
    required this.bottomMenuIndex,
    this.tabBarList,
    required this.tabController,
  });

  final Color? background;
  final String? title;
  final Widget body;
  final int bottomMenuIndex;
  final List<String>? tabBarList;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: background,
      body: NestedScrollView(
        physics: const PageScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          if (title == null) {
            return const <Widget>[];
          }

          return _buildSliverAppBar(
            context,
            innerBoxIsScrolled: innerBoxIsScrolled,
          );
        },
        body: body,
      ),
      bottomNavigationBar: OpenFlutterBottomMenu(bottomMenuIndex),
    );
  }

  List<Widget> _buildSliverAppBar(
    BuildContext context, {
    required bool innerBoxIsScrolled,
  }) {
    final theme = Theme.of(context);

    final tabs =
        tabBarList?.map((tabTitle) => Tab(text: tabTitle)).toList() ??
        const <Tab>[];

    final PreferredSizeWidget? tabWidget = tabs.isNotEmpty
        ? TabBar(
            controller: tabController,
            tabs: tabs,
            unselectedLabelColor: theme.colorScheme.primary,
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
            labelColor: theme.colorScheme.primary,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            indicatorColor: theme.colorScheme.secondary,
            indicatorSize: TabBarIndicatorSize.tab,
          )
        : null;

    return <Widget>[
      SliverAppBar(
        expandedHeight: AppSizes.app_bar_expanded_size,
        floating: false,
        pinned: true,
        forceElevated: innerBoxIsScrolled,
        bottom: tabWidget,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            color: AppColors.black,
            tooltip: 'Buscar',
            onPressed: () {
              debugPrint('Search favourites.');
            },
          ),
        ],
        flexibleSpace: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final availableHeight =
                AppSizes.app_bar_expanded_size - kToolbarHeight;

            final currentHeight = constraints.maxHeight - kToolbarHeight;

            final percent = availableHeight > 0
                ? (currentHeight * 100 / availableHeight).clamp(0.0, 100.0)
                : 0.0;

            final dx = 100.0 - percent;

            return Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: kToolbarHeight / 4),
                  child: Transform.translate(
                    offset: Offset(dx, constraints.maxHeight - kToolbarHeight),
                    child: Text(title!, style: theme.textTheme.bodySmall),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    ];
  }
}
