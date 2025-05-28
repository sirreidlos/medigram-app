import 'package:flutter/material.dart';
import 'package:medigram_app/constants/user_status.dart';
import 'package:medigram_app/page/home.dart';
import 'package:medigram_app/page/profile.dart';
import 'package:medigram_app/page/record.dart';
import 'package:medigram_app/constants/style.dart';

class BottomNavigationMenu extends StatefulWidget {
  const BottomNavigationMenu(this.isPatient, {this.initialIndex = 0 , super.key});
  final int initialIndex;
  final bool isPatient;

  @override
  State<BottomNavigationMenu> createState() => _BottomNavigationMenuState();
}

class _BottomNavigationMenuState extends State<BottomNavigationMenu> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  void onTapMenu(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    SharedPrefsHelper.saveUserRole(widget.isPatient);
    final List<Widget> pages = [
      HomePage(),
      RecordPage(),
      ProfilePage()
    ];
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Color(secondaryColor2),
        unselectedItemColor: Color(secondaryColor1),
        selectedItemColor: Colors.white,
        iconSize: 30,
        currentIndex: currentIndex,
        onTap: onTapMenu,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: ""),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment_outlined),
              activeIcon: Icon(Icons.assignment),
              label: ""),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined),
              activeIcon: Icon(Icons.person_2_rounded),
              label: ""),
        ],
      ),
    );
  }
}
