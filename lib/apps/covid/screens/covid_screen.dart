import 'package:flutter_erp/apps/covid/screens/home.dart';
import 'package:flutter_erp/apps/covid/screens/stats.dart';
import 'package:flutter/material.dart';

class CovidScreen extends StatefulWidget {
  const CovidScreen({Key? key}) : super(key: key);

  @override
  State<CovidScreen> createState() => _CovidScreenState();
}

class _CovidScreenState extends State<CovidScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    HomeScreen(),
    StatsScreen(),
    Scaffold(),
    Scaffold(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() {
          _currentIndex = index;
        }),
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        items: _buildNavItems(),
      ),
    );
  }

  dynamic _buildNavItems() {
    return [Icons.home, Icons.insert_chart, Icons.event_note, Icons.info]
        .asMap()
        .map(
          (key, value) => MapEntry(
            key,
            BottomNavigationBarItem(
              label: '',
              icon: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: _currentIndex == key
                      ? Colors.blue[300]
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Icon(value),
              ),
            ),
          ),
        )
        .values
        .toList();
  }
}
