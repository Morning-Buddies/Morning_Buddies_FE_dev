import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morning_buddies/models/groupinfo_controller.dart';
import 'package:morning_buddies/utils/design_palette.dart';

class HomeGroupDetail extends StatefulWidget {
  const HomeGroupDetail({super.key});

  @override
  State<HomeGroupDetail> createState() => _HomeGroupDetailState();
}

class _HomeGroupDetailState extends State<HomeGroupDetail> {
  bool isJoined = false;

  late final GroupInfoStatus groupData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    groupData = Get.arguments as GroupInfoStatus;
  }

  void _joinGroup() {
    // 추후 /groups/{groupId}/join-request 로 POST 로직 필요
    setState(() {
      isJoined = true;
    });
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('Move to Group-Chat'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to group chat
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Leave Group'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  isJoined = false;
                });
                // Handle group leaving
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(groupData.group_name),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Divider(),
            const SizedBox(height: 4),
            Container(
              width: 390,
              height: 200,
              decoration: const BoxDecoration(color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        groupData.group_name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isJoined)
                        IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.more_horiz,
                              color: ColorStyles.orange),
                          onPressed: _showOptionsMenu,
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Image(
                        image: AssetImage('assets/images/logo_solo-bird.png'),
                        height: 20,
                      ),
                      const SizedBox(width: 8),
                      Text('현재 ${groupData.current_participants}명'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text(groupData.wake_up_time),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    groupData.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 36),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Members',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${groupData.current_participants} / ${groupData.max_participants}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // group 정보 DB에서 가져와야함
                  const Column(
                    children: [
                      MemberTile(name: '조완기'),
                      MemberTile(name: '백태균'),
                      MemberTile(name: '박동규'),
                      MemberTile(name: '박찬주'),
                    ],
                  ),
                  const SizedBox(height: 36),
                  if (!isJoined)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _joinGroup,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: const Text(
                          'Newly Join to be a Newbie!',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MemberTile extends StatelessWidget {
  final String name;

  const MemberTile({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
          ),
          const SizedBox(width: 16),
          Text(
            name,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
