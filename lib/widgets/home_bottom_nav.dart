import 'package:flutter/material.dart';
import 'package:morning_buddies/screens/home/home_chat.dart';
import 'package:morning_buddies/screens/home/home_create.dart';
import 'package:morning_buddies/screens/home/home_main.dart';
import 'package:morning_buddies/screens/home/home_profile.dart';
import 'package:morning_buddies/utils/design_palette.dart';

class HomeBottomNav extends StatefulWidget {
  const HomeBottomNav({super.key});

  @override
  State<HomeBottomNav> createState() => _HomeBottomNavState();
}

class _HomeBottomNavState extends State<HomeBottomNav> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const HomeMain(),
    const HomeCreate(),
    const HomeChat(),
    const HomeProfile(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: ColorStyles.secondaryOrange,
        currentIndex: _currentIndex,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
            print(_currentIndex);
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_box_outlined), label: "Create"),
          BottomNavigationBarItem(icon: Icon(Icons.inbox), label: "chat"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "profile"),
        ],
        type: BottomNavigationBarType.fixed, // Optional for clarity
      ),
    );
  }
}