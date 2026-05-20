import 'package:flutter/material.dart';

class GalleryDemoCategory {

  final String? name;
  
  final IconData? icon;

  const GalleryDemoCategory({
    this.name,
    this.icon,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GalleryDemoCategory &&
          other.name == name &&
          other.icon == icon;

  @override
  int get hashCode => Object.hash(name, icon);

  @override
  String toString() => 'GalleryDemoCategory(name: $name)';
}

class GalleryDemo {
  const GalleryDemo({
    required this.title,
    required this.icon,
    this.subtitle,
    required this.category,
    required this.routeName,
    required this.buildRoute,
  }) : assert(title != null),
       assert(category != null),
       assert(routeName != null),
       assert(buildRoute != null);

  final String title;
  final IconData icon;
  final String? subtitle;
  final GalleryDemoCategory category;
  final String routeName;
  final WidgetBuilder buildRoute;

  @override
  String toString() {
    return '$runtimeType($title $routeName)';
  }
}

List<GalleryDemo> _buildGalleryDemos() {
  final List<GalleryDemo> galleryDemos = <GalleryDemo>[
    // Demos
    // new GalleryDemo(
    //   title: 'Shrine',
    //   subtitle: 'Basic shopping app',
    //   icon: GalleryIcons.shrine,
    //   category: _kDemos,
    //   routeName: ShrineDemo.routeName,
    //   buildRoute: (BuildContext context) => new ShrineDemo(),
    // ),

  ];

  // Keep Pesto around for its regression test value. It is not included
  // in (release builds) the performance tests.
 

  return galleryDemos;
}

final List<GalleryDemo> kAllGalleryDemos = _buildGalleryDemos();

final Set<GalleryDemoCategory> kAllGalleryDemoCategories =
  kAllGalleryDemos.map<GalleryDemoCategory>((GalleryDemo demo) => demo.category).toSet();

final Map<GalleryDemoCategory, List<GalleryDemo>> kGalleryCategoryToDemos =
  new Map<GalleryDemoCategory, List<GalleryDemo>>.fromIterable(
    kAllGalleryDemoCategories,
    value: (dynamic category) {
      return kAllGalleryDemos.where((GalleryDemo demo) => demo.category == category).toList();
    },
  );
