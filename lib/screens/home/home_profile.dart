// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:morning_buddies/models/groupinfo_controller.dart';
import 'package:morning_buddies/screens/subscription_screen.dart';
import 'package:morning_buddies/utils/design_palette.dart';
import 'package:morning_buddies/widgets/dropdown/custom_dropdown.dart';
import 'package:morning_buddies/widgets/button/section_with_btn.dart';

class HomeProfile extends StatefulWidget {
  const HomeProfile({super.key});

  @override
  State<HomeProfile> createState() => _HomeProfileState();
}

class _HomeProfileState extends State<HomeProfile> {
  String _userName = "Loading..."; // Initial state with a placeholder

  Future<void> getUserName() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? currentUser = auth.currentUser;

    if (currentUser != null) {
      String uid = currentUser.uid;
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('Users').doc(uid).get();

      if (userDoc.exists) {
        String name = "${userDoc['lastname']} ${userDoc['firstname']}";
        if (mounted) {
          setState(() {
            _userName = name;
          });
        }
        print("User Name: $name");
      } else {
        print("User document does not exist.");
      }
    } else {
      print("No user is signed in.");
    }
  }

  @override
  void initState() {
    super.initState();
    getUserName();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final GroupStatusController groupStatusController = Get.find();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _ProfileCard(name: _userName),
              const SizedBox(height: 16.0),
              // Pixel Err
              const _SectionTitle("Your Performance"),
              const SizedBox(height: 16.0),
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
                  onPressed: () => Get.toNamed('/my_group_detail')),
              const SizedBox(height: 16.0),

              const GroupStatusList(),
            ],
          ),
        ),
      ),
    );
  }
}

// Profile Card
class _ProfileCard extends StatefulWidget {
  final String name;

  const _ProfileCard({required this.name});

  @override
  State<_ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<_ProfileCard> {
  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  Future getImage(ImageSource imageSource) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    final XFile? pickedFile = await _picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path); //가져온 이미지를 _image에 저장
        // 💡 추후 GET / POST 로직 필요
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Stack(children: [
              _image != null
                  ? CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(_image!.path),
                      // backgroundColor: Colors.transparent,
                    )
                  : const CircleAvatar(
                      radius: 30, backgroundColor: Colors.grey),
              Positioned(
                left: 30,
                bottom: 20,
                child: IconButton(
                  iconSize: 12,
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    getImage(ImageSource.gallery);
                  },
                  icon: const Icon(Icons.photo_camera),
                ),
              )
            ]),
            const SizedBox(width: 16),
            Expanded(
              // Expanded 추가
              child: Row(
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.toNamed('/setting'),
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
    // Fixed card size (width and height)
    double cardWidth = 176;
    double cardHeight = 76;

    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // TIME Preferred
          const SizedBox(
            child: TimePreferenceRow(),
          ),
          // Alarm Performance
          SizedBox(
            width: cardWidth,
            height: cardHeight,
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
                    SizedBox(height: 4),
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
  const GroupStatusList({super.key});
  @override
  Widget build(BuildContext context) {
    final GroupinfoController groupinfoController = Get.find();
    return SizedBox(
      height: 100,
      child: Obx(() {
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: groupinfoController.getResponse.length + 1,
          itemBuilder: (context, index) {
            if (index < groupinfoController.getResponse.length) {
              return _GroupStatusCard(
                  group: groupinfoController.getResponse[index]);
            } else {
              return const _UpgradeCard();
            }
          },
        );
      }),
    );
  }
}

class _GroupStatusCard extends StatelessWidget {
  final GroupInfoStatus group;

  const _GroupStatusCard({required this.group});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 176,
      child: Card(
        color: Colors.white,
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
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.grey,
                    foregroundImage:
                        AssetImage("assets/images/logo_solo-bird.png"),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: 110,
                        child: Text(
                          group.group_name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Text(
                      //   group.status,
                      //   style:
                      //       const TextStyle(fontSize: 10, color: Colors.grey),
                      // ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                group.wake_up_time,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
