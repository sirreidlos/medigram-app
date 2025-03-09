import 'package:flutter/material.dart';
import 'package:medigram_app/page/home.dart';
import 'package:medigram_app/page/profile.dart';
import 'package:medigram_app/page/record.dart';
import 'package:medigram_app/constants/style.dart';

class BottomNavigationMenu extends StatefulWidget {
  const BottomNavigationMenu({super.key});

  @override
  State<BottomNavigationMenu> createState() => _BottomNavigationMenuState();
}

class _BottomNavigationMenuState extends State<BottomNavigationMenu> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    HomePage(),
    RecordPage(),
    ProfilePage()
  ];

  void onTapMenu(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Color(secondaryColor2),
        unselectedItemColor: Color(secondaryColor1),
        selectedItemColor: Colors.white,
        iconSize: 30,
        currentIndex: _currentIndex,
        onTap: onTapMenu,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: ""
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: ""
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            activeIcon: Icon(Icons.person_2_rounded),
            label: ""
          ),
        ],
      ),
    );
  }
}