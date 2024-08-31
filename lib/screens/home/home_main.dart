import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morning_buddies/models/groupinfo_controller.dart';
import 'package:morning_buddies/utils/design_palette.dart';
import 'package:morning_buddies/widgets/button/section_with_btn.dart';

class HomeMain extends StatefulWidget {
  const HomeMain({super.key});

  @override
  State<HomeMain> createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  final GroupinfoController _groupinfoController =
      Get.put(GroupinfoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: 164,
        leading: Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: Image.asset(
            'assets/images/main_logo.png',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none,
                color: Colors.black), // 알림 아이콘
            onPressed: () {
              // notification 이동
            },
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black), // 검색 아이콘
            onPressed: () => Get.toNamed('/search'),
          ),
          const SizedBox(width: 16) // 오른쪽 패딩 추가
        ],
      ),
      body: Center(
        child: Obx(() {
          if (_groupinfoController.getResponse.isEmpty) {
            return const CircularProgressIndicator(); // 로딩 표시
          } else {
            return ListView(
              children: [
                const SizedBox(height: 4),
                Container(
                  width: 414,
                  height: 200,
                  decoration: const BoxDecoration(color: Colors.grey),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SectionWithButton(
                        title: "Hot Groups",
                        buttonText: "more",
                        onPressed: () {},
                      ),
                      _buildGroupList(_groupinfoController.getResponse),
                      SectionWithButton(
                        title: "Early Morning Wakers",
                        buttonText: "more",
                        onPressed: () {},
                      ),
                      _buildGroupList(_groupinfoController.getResponse),
                      SectionWithButton(
                        title: "Wake Like an Owl",
                        buttonText: "more",
                        onPressed: () {},
                      ),
                      _buildGroupList(_groupinfoController.getResponse),
                    ],
                  ),
                ),
              ],
            );
          }
        }),
      ),
    );
  }

  Widget _buildGroupList(List<GroupInfoStatus> groupData) {
    return SizedBox(
      height: 150, // 각 아이템의 높이에 맞춰 조절
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: groupData.length,
        itemBuilder: (context, index) {
          final group = groupData[index];
          return GestureDetector(
            onTap: () => Get.toNamed('/home_group_detail', arguments: group),
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              width: 120, // 각 아이템의 너비 조절
              height: 135, // 이미지 높이
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end, // 하단 정렬
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: 120,
                        height: 80,
                        child: Image.asset("assets/images/example.png")),
                    Text(group.group_name,
                        style:
                            const TextStyle(fontSize: 8, color: Colors.black)),
                    Text(group.wake_up_time,
                        style: const TextStyle(
                            fontSize: 8, color: ColorStyles.secondaryOrange)),
                    Text(
                        '${group.current_participants}/${group.max_participants}',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.black)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
