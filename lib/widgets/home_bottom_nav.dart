import 'package:flutter/material.dart';
import 'package:morning_buddies/screens/game/game_start.dart';
import 'package:morning_buddies/screens/home/chat/group_chat_list_page.dart';
import 'package:morning_buddies/screens/home/home_create.dart';
import 'package:morning_buddies/screens/home/home_main.dart';
import 'package:morning_buddies/screens/home/home_profile.dart';
import 'package:morning_buddies/service/time_service.dart';
import 'package:morning_buddies/utils/design_palette.dart';

class HomeBottomNav extends StatefulWidget {
  const HomeBottomNav({super.key});

  @override
  State<HomeBottomNav> createState() => _HomeBottomNavState();
}

class _HomeBottomNavState extends State<HomeBottomNav> {
  final TimeService _timeService = TimeService();
  // TargetTime
  String targetTime = "23:59";

  // String to DateTime
  DateTime convertToDateTime(String targetTime) {
    DateTime now = DateTime.now();
    List<String> timeParts = targetTime.split(":");
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  late DateTime convertedTargetTime = convertToDateTime(targetTime);

  int _currentIndex = 0;
  final List<Widget> _pages = [
    const HomeMain(),
    const HomeCreate(),
    GroupChatListPage(),
    const HomeProfile(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _timeService.alarmAction(convertedTargetTime, _navigateToGameScreen);
    });
  }

  @override
  void dispose() {
    _timeService.dispose();
    super.dispose();
  }

  void _navigateToGameScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const GameStart()),
    );
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
