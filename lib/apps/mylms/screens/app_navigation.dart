import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/mylms/services/auth/auth_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter_erp/apps/mylms/screens/account/account.dart';
import 'package:flutter_erp/apps/mylms/screens/home/home.dart';
import 'package:flutter_erp/apps/mylms/screens/my_courses/my_courses.dart';
import 'package:flutter_erp/apps/mylms/screens/notifications/notification.dart';

class LMSAppNavigation extends StatefulWidget {
  const LMSAppNavigation({super.key});

  @override
  State<LMSAppNavigation> createState() => _LMSAppNavigationState();
}

class _LMSAppNavigationState extends State<LMSAppNavigation> {
  int _selectedIndex = 0;

  late final Future<void> _authInitialization;

  @override
  void initState() {
    super.initState();

    _authInitialization = AuthService.init();
  }

  void _change(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _authInitialization,
      builder: (context, snapshot) {
        // Inicializando AuthService
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Error durante inicialización
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error initializing LMS: ${snapshot.error}'),
            ),
          );
        }

        // AuthService ya está listo
        return Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: [Home(), MyCourses(), Notifications(), Account()],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _change,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.graduationCap),
                label: 'My Courses',
              ),
              BottomNavigationBarItem(
                icon: Badge(label: Text('3'), child: Icon(Icons.notifications)),
                label: 'Notification',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Account',
              ),
            ],
          ),
        );
      },
    );
  }
}
