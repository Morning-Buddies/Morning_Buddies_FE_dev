import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:morning_buddies/utils/design_palette.dart';
import 'package:morning_buddies/widgets/section_with_btn.dart';

class HomeMain extends StatefulWidget {
  const HomeMain({super.key});

  @override
  State<HomeMain> createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  // Sample data (API 연동 후 실제 데이터로 대체)
  final List<Map<String, dynamic>> hotGroups = [
    {'title': '출근 전 헬스', 'time': '6:00', 'participants': '2/10'},
    {'title': '출근 전 헬스', 'time': '6:00', 'participants': '2/10'},
    {'title': '출근 전 헬스', 'time': '6:00', 'participants': '2/10'},
  ];

  final List<Map<String, dynamic>> earlyWakers = [
    // ... (API 연동 후 실제 데이터로 대체)
    {'title': '출근 전 헬스', 'time': '6:00', 'participants': '2/10'},
    {'title': '출근 전 헬스', 'time': '6:00', 'participants': '2/10'},
    {'title': '출근 전 헬스', 'time': '6:00', 'participants': '2/10'},
  ];
  final List<Map<String, dynamic>> wakeOwls = [
    // ... (API 연동 후 실제 데이터로 대체)
    {'title': '출근 전 헬스', 'time': '6:00', 'participants': '2/10'},
    {'title': '출근 전 헬스', 'time': '6:00', 'participants': '2/10'},
    {'title': '출근 전 헬스', 'time': '6:00', 'participants': '2/10'},
  ];
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
            // height: 40,
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
            onPressed: () => Get.to(const HomeSearch()),
          ),
          const SizedBox(width: 16) // 오른쪽 패딩 추가
        ],
      ),
      body: Center(
        child: ListView(
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
                  _buildGroupList(hotGroups),
                  SectionWithButton(
                    title: "Early Moring Wakers",
                    buttonText: "more",
                    onPressed: () {},
                  ),
                  _buildGroupList(earlyWakers),
                  SectionWithButton(
                    title: "Wake Like an Owl",
                    buttonText: "more",
                    onPressed: () {},
                  ),
                  _buildGroupList(wakeOwls),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupList(List<Map<String, dynamic>> groupData) {
    return SizedBox(
      height: 150, // 각 아이템의 높이에 맞춰 조절
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: groupData.length,
        itemBuilder: (context, index) {
          final group = groupData[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomeGroupDetail()));
            },
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
                    Text(group['title'],
                        style:
                            const TextStyle(fontSize: 12, color: Colors.black)),
                    Text(group['time'],
                        style: const TextStyle(
                            fontSize: 12, color: ColorStyles.orange)),
                    Text(group['participants'],
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
