import 'package:flutter/material.dart' hide Page;
import 'package:flutter_erp/apps/flutter_app/TripListItem.tab.dart';
import 'package:flutter_erp/apps/flutter_app/models/trip_model.dart';
import 'package:flutter_erp/apps/flutter_app/page.dart';
import 'package:flutter_erp/apps/flutter_app/trip_data.dart';

final Map<Page, List<TripInfo>> _allPages = <Page, List<TripInfo>>{

  Page(label: 'ACTIVE'): dummyTrips.where((i) => i.completed == "On Going").toList()
  ,
  Page(label: 'HISTORY'): dummyTrips.where((i) => i.completed == "Cancelled" || i.completed == "Finished").toList()
};


class BookingScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _allPages.length,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  //title: const Text(''),
    
                  pinned: true,
                  expandedHeight: 100.0,
                  forceElevated: innerBoxIsScrolled,
                  bottom: TabBar(
                    tabs: _allPages.keys.map(
                      (Page page) => Tab(text: page.label),
                    ).toList(),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: _allPages.keys.map((Page page) {
              return SafeArea(
                top: false,
                bottom: false,
                child: Builder(
                  builder: (BuildContext context) {
                    return CustomScrollView(
                      key: PageStorageKey<Page>(page),
                      slivers: <Widget>[
                        SliverOverlapInjector(
                          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          sliver: SliverFixedExtentList(                       
                            itemExtent: TripListTabItem.height,
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                final TripInfo data = _allPages[page]!.elementAt(index);
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  child: TripListTabItem(
                                    page: page,
                                    
                                    data: data,
                                  ),
                                );
                              },
                              childCount: _allPages[page]!.length,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}