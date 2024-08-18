import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:get/route_manager.dart';
=======
import 'package:get/get.dart';
import 'package:morning_buddies/models/group_controller.dart';
import 'package:morning_buddies/utils/design_palette.dart';
>>>>>>> 246c062 (FEAT: My Groups GetX적용 및 UI 추가)

class MyGroupDetail extends StatefulWidget {
  const MyGroupDetail({super.key});

  @override
  State<MyGroupDetail> createState() => _MyGroupDetailState();
}

class _MyGroupDetailState extends State<MyGroupDetail> {
  /* 
    💡 현재 List<GroupList> 를 받아오면 됨,
    다만, 기본 데이터 타입과 Map형태만을 지원하기에 직렬화가 필요
  */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
<<<<<<< HEAD
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [],
=======
        title: const Text(
          "My Groups",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Obx(() {
            return ListView.separated(
              shrinkWrap: true,
              itemCount: groupStatusController.groups.length,
              itemBuilder: (context, index) {
                final group = groupStatusController.groups[index];
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.grey,
                    // image
                  ),
                  title: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                            text: group.name,
                            style: const TextStyle(fontSize: 14)),
                        const TextSpan(
                            text: " ", style: TextStyle(fontSize: 14)),
                        TextSpan(
                            text: group.time,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.more_horiz),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: 240,
                            width: double.infinity,
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Are you sure to leave this grop?"),
                                const SizedBox(height: 36),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        minimumSize: const Size(172, 47),
                                        foregroundColor:
                                            ColorStyles.secondaryOrange,
                                        backgroundColor: Colors.white,
                                        side: const BorderSide(
                                            width: 2.0,
                                            color: ColorStyles.secondaryOrange),
                                      ),
                                      onPressed: () {
                                        groupStatusController
                                            .removeGroup(group);
                                        Navigator.pop(
                                            context); // Close the bottom sheet
                                      },
                                      child: const Text('Yes'),
                                    ),
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        minimumSize: const Size(172, 47),
                                        foregroundColor: Colors.white,
                                        backgroundColor:
                                            ColorStyles.secondaryOrange,
                                        side: const BorderSide(
                                            width: 2.0,
                                            color: ColorStyles.secondaryOrange),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            );
          }),
          GestureDetector(
            onTap: () => Get.toNamed('/subscription_screen'),
            child: Container(
              width: double.infinity,
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
          ),
        ],
>>>>>>> 246c062 (FEAT: My Groups GetX적용 및 UI 추가)
      ),
    );
  }
}
