import 'package:flutter/material.dart';

class ListCategory extends StatelessWidget {
  const ListCategory({Key? key, this.icon, this.children}) : super(key: key);

  final IconData? icon;

  final List<Widget>? children;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: themeData.dividerColor)),
      ),
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.titleMedium!,
        child: SafeArea(
          top: false,
          bottom: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                width: 72.0,
                child: Icon(icon, color: themeData.primaryColor),
              ),
              Expanded(child: Column(children: children!)),
            ],
          ),
        ),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  ListItem({Key? key, this.icon, this.lines, this.tooltip, this.onPressed})
    : assert(lines!.length > 1),
      super(key: key);

  final IconData? icon;
  final List<String>? lines;
  final String? tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final List<Widget> columnChildren = lines!
        .sublist(0, lines!.length - 1)
        .map((String line) => Text(line))
        .toList();
    columnChildren.add(Text(lines!.last, style: themeData.textTheme.bodySmall));

    final List<Widget> rowChildren = <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: columnChildren,
        ),
      ),
    ];
    if (icon != null) {
      rowChildren.add(
        SizedBox(
          width: 72.0,
          child: IconButton(
            icon: Icon(icon),
            color: themeData.primaryColor,
            onPressed: onPressed,
          ),
        ),
      );
    }
    return MergeSemantics(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: rowChildren,
        ),
      ),
    );
  }
}

class PromoFragment extends StatefulWidget {
  static const String routeName = '/promo';

  @override
  PromoState createState() => PromoState();
}

enum AppBarBehavior { normal, pinned, floating, snapping }

class PromoState extends State<PromoFragment> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  final double _appBarHeight = 256.0;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.indigo,
        platform: Theme.of(context).platform,
      ),
      child: Scaffold(
        key: _scaffoldKey,
        body: CustomScrollView(
          slivers: <Widget>[
            AppBar(
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.create),
                  tooltip: 'Edit',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Editing isn't supported in this screen.",
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            ListView(
              children: <Widget>[
                ListCategory(
                  icon: Icons.call,
                  children: <Widget>[
                    ListItem(
                      icon: Icons.message,
                      tooltip: 'Send message',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Editing isn't supported in this screen.",
                            ),
                          ),
                        );
                      },
                      lines: const <String>['(650) 555-1234', 'Mobile'],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
