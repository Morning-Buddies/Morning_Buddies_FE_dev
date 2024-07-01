import 'package:flutter/material.dart';
import 'package:morning_buddies/utils/design_palette.dart';

class HomeProfile extends StatefulWidget {
  const HomeProfile({super.key});

  @override
  State<HomeProfile> createState() => _HomeProfileState();
}

class _HomeProfileState extends State<HomeProfile> {
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
    return SafeArea(
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
            const _SectionWithButton("Subscription", "View Details"),
            const SizedBox(height: 16.0),
            const _UpgradeCard(),
            const SizedBox(height: 16.0),
            const _SectionWithButton("Your Groups", "View Details"),
            GroupStatusList(groups: _groups),
          ],
        ),
      ),
    );
  }
}

// Profile Card
class _ProfileCard extends StatelessWidget {
  final String name;

  const _ProfileCard({super.key, required this.name});

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {}, // 설정 화면 이동 로직 추가
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

  const _SectionTitle(this.title, {super.key});

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

// Section with Button
class _SectionWithButton extends StatelessWidget {
  final String title;
  final String buttonText;

  const _SectionWithButton(this.title, this.buttonText, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _SectionTitle(title),
        _BorderedTextButton(buttonText),
      ],
    );
  }
}

// Bordered Text Button
class _BorderedTextButton extends StatelessWidget {
  final String text;

  const _BorderedTextButton(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      style: ButtonStyle(
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: const BorderSide(color: ColorStyles.secondaryOrange),
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: ColorStyles.secondaryOrange,
              fontSize: 12,
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_right,
            color: ColorStyles.secondaryOrange,
            size: 16.0,
          ),
        ],
      ),
    );
  }
}

// Upgrade Card
class _UpgradeCard extends StatelessWidget {
  const _UpgradeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

// 기존 TimePreferenceRow, PerformanceCard 클래스는 변경 없음

class TimePreferenceRow extends StatefulWidget {
  const TimePreferenceRow({super.key});

  @override
  State<TimePreferenceRow> createState() => _TimePreferenceRowState();
}

class _TimePreferenceRowState extends State<TimePreferenceRow> {
  String _selectedTime = '07:00';
  bool _isEditing = false; // Track editing state

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
                  if (_isEditing) // Dropdown for editing
                    DropdownButton<String>(
                      value: _selectedTime,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedTime = newValue!;
                        });
                      },
                      items: <String>[
                        '00:00',
                        '01:00',
                        '02:00',
                        '03:00',
                        '04:00',
                        '05:00',
                        '06:00',
                        '07:00',
                        '08:00',
                        '09:00',
                        '10:00',
                        '11:00',
                        '12:00',
                        '13:00',
                        '14:00',
                        '15:00',
                        '16:00',
                        '17:00',
                        '18:00',
                        '19:00',
                        '20:00',
                        "21:00",
                        "22:00",
                        "23:00",
                        "24:00",
                        // Add more time options here
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )
                  else // Text display for non-editing
                    Container(
                      width: 156,
                      height: 28,
                      decoration: BoxDecoration(
                        border: Border.all(color: ColorStyles.secondaryOrange),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            _selectedTime,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isEditing = true; // Start editing
                              });
                            },
                            child: const Text("edit",
                                style: TextStyle(
                                  fontSize: 8,
                                  color: ColorStyles.secondaryOrange,
                                )),
                          ),
                        ],
                      ),
                    ),
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

  const _GroupStatusCard({super.key, required this.group});

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
