import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:get/route_manager.dart';
import 'package:morning_buddies/screens/home/my_group_detail.dart';
=======
import 'package:get/get.dart';
import 'package:morning_buddies/models/group_controller.dart';
>>>>>>> 246c062 (FEAT: My Groups GetX적용 및 UI 추가)
import 'package:morning_buddies/screens/home/home_setting.dart';
import 'package:morning_buddies/screens/subscription_screen.dart';
import 'package:morning_buddies/utils/design_palette.dart';
import 'package:morning_buddies/widgets/custom_dropdown.dart';
import 'package:morning_buddies/widgets/section_with_btn.dart';

class HomeProfile extends StatefulWidget {
  const HomeProfile({super.key});

  @override
  State<HomeProfile> createState() => _HomeProfileState();
}

class _HomeProfileState extends State<HomeProfile> {
<<<<<<< HEAD
  final List<GroupStatus> _groups = [
    GroupStatus(
      name: "Group 1",
      status: "Missed",
      time: "6:30 AM",
    ),
    GroupStatus(
      name: "Group 2",
      status: "Dismissed",
      time: "7:00 AM",
    ),
    GroupStatus(
      name: "Group 3",
      status: "Dismissed",
      time: "8:00 AM",
    ),
    // 더 많은 그룹 추가
  ];

  @override
  Widget build(BuildContext context) {
=======
  @override
  Widget build(BuildContext context) {
    // final GroupStatusController groupStatusController = Get.find();

>>>>>>> 246c062 (FEAT: My Groups GetX적용 및 UI 추가)
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const _ProfileCard(name: "John Doe"),
              const SizedBox(height: 16.0),
              const _SectionTitle("Your Performance"),
              const PerformanceCard(),
              const SizedBox(height: 16.0),
              SectionWithButton(
                title: "Subscription",
                buttonText: "Vew Details",
                onPressed: () {},
              ),
              const SizedBox(height: 16.0),
              const _UpgradeCard(),
              const SizedBox(height: 16.0),
              SectionWithButton(
                  title: "Your Groups",
                  buttonText: "View Details",
                  // 💡 라우트 관리 + 상태관리 필요
                  onPressed: () =>
                      Get.to(const MyGroupDetail(), arguments: _groups)),
              GroupStatusList(groups: _groups),
            ],
          ),
        ),
      ),
    );
  }
}

// Profile Card
class _ProfileCard extends StatelessWidget {
  final String name;

  const _ProfileCard({required this.name});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const CircleAvatar(radius: 30, backgroundColor: Colors.grey),
            const SizedBox(width: 16),
            Expanded(
              // Expanded 추가
              child: Row(
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeSetting()),
                      );
                    },
                    icon: const Icon(Icons.settings),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Section Title
class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// Upgrade Card
class _UpgradeCard extends StatelessWidget {
  const _UpgradeCard();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Subscription 결제 화면 이동
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SubscriptionScreen()),
        );
        print("결제 화면 이동");
      },
      child: Container(
        width: 360,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: const Color(0x10ABABB5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
              children: [
                Image.asset(
                  "assets/images/add_custom_icon.png", // 이미지 경로 확인
                ),
                const SizedBox(height: 4.0),
                const Text(
                  "Upgrade to a Pro-Mode\nJoin in more groups", // 텍스트 한 줄로 합침
                  style: TextStyle(
                    fontSize: 10,
                    color: ColorStyles.secondaryOrange,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center, // 텍스트 중앙 정렬
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TimePreferenceRow extends StatefulWidget {
  const TimePreferenceRow({super.key});

  @override
  State<TimePreferenceRow> createState() => _TimePreferenceRowState();
}

class _TimePreferenceRowState extends State<TimePreferenceRow> {
  String _selectedTime = '07:00 AM';
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 176,
          height: 76,
          child: Card(
            color: Colors.transparent,
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
              side: const BorderSide(color: Colors.grey, width: 0.1),
            ),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Time Preferred",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  CustomDropdown(
                    value: _selectedTime,
                    items: const <String>[
                      '00:00 AM',
                      '01:00 AM',
                      '02:00 AM',
                      '03:00 AM',
                      '04:00 AM',
                      '05:00 AM',
                      '06:00 AM',
                      '07:00 AM',
                      '08:00 AM',
                      '09:00 AM',
                      '10:00 AM',
                      '11:00 AM',
                      '12:00 PM',
                    ],
                    onChanged: (newValue) {
                      setState(() {
                        _selectedTime = newValue;
                      });
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PerformanceCard extends StatelessWidget {
  const PerformanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const TimePreferenceRow(),
          SizedBox(
            width: 176,
            height: 76,
            child: Card(
              elevation: 0,
              color: Colors.transparent,
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
                side: const BorderSide(color: Colors.grey, width: 0.1),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Alarm Performance",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "8 times Recoreded",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class GroupStatusList extends StatelessWidget {
  final List<GroupStatus> groups;

  const GroupStatusList({super.key, required this.groups});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: groups.length + 1, // 추가된 "Upgrade" 카드
        itemBuilder: (context, index) {
          if (index < groups.length) {
            return _GroupStatusCard(group: groups[index]);
          } else {
            return const _UpgradeCard();
          }
        },
      ),
    );
  }
}

class GroupStatus {
  final String name;
  final String status;
  final String time;

  GroupStatus({required this.name, required this.status, required this.time});
}

class _GroupStatusCard extends StatelessWidget {
  final GroupStatus group;

  const _GroupStatusCard({required this.group});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 176,
      child: Card(
        elevation: 0,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: const BorderSide(color: Colors.grey, width: 0.1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(
                    Icons.circle,
                    size: 32, // 아이콘 크기 줄임
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Column(
                    children: [
                      Text(
                        group.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        group.status,
                        style:
                            const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                group.time,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
