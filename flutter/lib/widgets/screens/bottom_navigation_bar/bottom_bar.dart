import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Navigate to the selected screen
    switch (index) {
      case 0:
        GoRouter.of(context).go('/profile');
        break;
      case 1:
        GoRouter.of(context).go('/start');
        break;
      case 2:
        GoRouter.of(context).go('/lobby');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Game',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      );
  }
}