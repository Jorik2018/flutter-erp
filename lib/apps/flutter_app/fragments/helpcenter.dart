import 'package:flutter/material.dart';
// Uncomment lines 7 and 10 to view the visual layout at runtime.
//import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;

void main() {
  //debugPaintSizeEnabled = true;
  runApp( HelpCenter());
}

class HelpCenter extends StatefulWidget {
  HelpCenter({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  HelpCenterState createState() =>  HelpCenterState();
}

// Widget topImageDisplay(String value, BuildContext context) {
//   final ThemeData themeData = Theme.of(context);
//   return  Container(
//     padding: const EdgeInsets.symmetric(vertical: 16.0),
//     decoration:  BoxDecoration(
//         border:
//              Border(bottom:  BorderSide(color: themeData.dividerColor))),
//     child:  DefaultTextStyle(
//       style: Theme.of(context).textTheme.subhead,
//       child:  SafeArea(
//         top: false,
//         bottom: false,
//         child:  Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             //  Container(
//             //     padding: const EdgeInsets.symmetric(vertical: 24.0),
//             //     width: 72.0,
//             //     child:  Icon(icon, color: themeData.primaryColor)),
//             //  Expanded(child:  Column(children: children))
//           ],
//         ),
//       ),
//     ),
//   );
// }

enum AppBarBehavior { normal, pinned, floating, snapping }

class HelpCenterState extends State<HelpCenter> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
       GlobalKey<ScaffoldState>();
  final double _appBarHeight = 256.0;

  AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;

  @override
  Widget build(BuildContext context) {
    const String img = "http://via.placeholder.com/350x150";
    return  Scaffold(
        // ...
        key: _scaffoldKey,
        body:  CustomScrollView(slivers: <Widget>[
           SliverAppBar(
            expandedHeight: _appBarHeight,
            pinned: true,
            flexibleSpace:  FlexibleSpaceBar(
              title:  Column(children: <Widget>[
                 Text('xxx',
                    style:  TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 20.0)),
                 Text('johndoe@example.com',
                    style:  TextStyle(
                        fontWeight: FontWeight.w200, fontSize: 16.0)),
              ]),
              background:  Stack(
                fit: StackFit.expand,
                children: <Widget>[
                   Container(
                    height: 300.0,
                    color: Colors.grey,
                    child:  Center(
                        child:  CircleAvatar(
                            backgroundImage: NetworkImage(img))),
                  ),
                  // This gradient ensures that the toolbar icons are distinct
                  // against the background image.
                  const DecoratedBox(
                    decoration: const BoxDecoration(
                      gradient: const LinearGradient(
                        begin: const Alignment(0.0, -1.0),
                        end: const Alignment(0.0, -0.4),
                        colors: const <Color>[
                          const Color(0x60000000),
                          const Color(0x00000000)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
           SliverList(
              delegate:  SliverChildListDelegate(<Widget>[
             ListTile(
              title:  Text('Guide To Order',
                  style:  TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 20.0)),
              trailing:  Icon(
                Icons.chevron_right,
                color: Colors.grey[500],
              ),
            ),
             ListTile(
              title:  Text('Products and Services',
                  style:  TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 20.0)),
              trailing:  Icon(
                Icons.chevron_right,
                color: Colors.grey[500],
              ),
            ),
             ListTile(
              title:  Text('Tips and Fare',
                  style:  TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 20.0)),
              trailing:  Icon(
                Icons.chevron_right,
                color: Colors.grey[500],
              ),
            ),

             ListTile(
              title:  Text('Account and Payment',
                  style:  TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 20.0)),
              trailing:  Icon(
                Icons.chevron_right,
                color: Colors.grey[500],
              ),
            ),

             ListTile(
              title:  Text('Promo and Awards',
                  style:  TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 20.0)),
              trailing:  Icon(
                Icons.chevron_right,
                color: Colors.grey[500],
              ),
            ),
            // ...
          ]))
        ]));
  }
}
