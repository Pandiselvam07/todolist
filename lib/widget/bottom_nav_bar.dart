import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todolist/presentation/UserPages/task_registration.dart';
import 'package:todolist/presentation/UserPages/view_task.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    TaskRegistration(),
    ViewTask(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        height: 60.0,
        items: <Widget>[
          FaIcon(FontAwesomeIcons.listCheck,
              size: 30,
              color: _currentIndex == 0 ? Color(0xffFF0000) : Colors.white),
          FaIcon(Icons.grid_view,
              size: 30,
              color: _currentIndex == 1 ? Color(0xffFF0000) : Colors.white),
        ],
        color: Color(0xFF00008B),
        buttonBackgroundColor: Color(0xffFF0000).withOpacity(0.2),
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
