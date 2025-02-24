import 'package:flutter/material.dart';
import 'package:medigram_app/page/home.dart';
import 'package:medigram_app/page/profile.dart';
import 'package:medigram_app/page/record.dart';

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
        currentIndex: _currentIndex,
        onTap: onTapMenu,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: ""
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_rounded),
            label: ""
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_rounded),
            label: ""
          ),
        ],
      ),
    );
  }
}