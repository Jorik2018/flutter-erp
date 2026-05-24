import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/flutter_ecommerce_app/main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavBarWidget extends StatefulWidget {
  @override
  _BottomNavBarWidgetState createState() => _BottomNavBarWidgetState();
}

class _BottomNavBarWidgetState extends State<BottomNavBarWidget> {
  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 0;
    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
        navigateToScreens(index);
      });
    }

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          /**The named parameter 'title' isn't defined.
Try correcting the name to an existing named parameter's name, or defining a named parameter with the name 'title' */
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          /**The argument type 'FaIconData' can't be assigned to the parameter type 'IconData?'. dartargument_type_not_assignable
A value of type 'FaIconData' can't be assigned to a parameter of type 'IconData?' in a const constructor.
Try using a subtype, or removing the keyword 'const' */
          icon: FaIcon(FontAwesomeIcons.heart),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.bagShopping),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.dashcube),
          label: 'Home',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Color(0xFFAA292E),
      onTap: _onItemTapped,
    );
  }
}
