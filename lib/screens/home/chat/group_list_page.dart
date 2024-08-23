import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morning_buddies/models/group_controller.dart';
import 'package:morning_buddies/screens/home/chat/chat_page.dart';

class GroupListPage extends StatelessWidget {
  GroupListPage({super.key});
  final GroupStatusController _groupStatusController =
      Get.put(GroupStatusController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Rooms'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _groupStatusController.fetchGroupsFromFirestore();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (_groupStatusController.groups.isEmpty) {
          return Center(child: Text('No groups found.'));
        }
        return ListView.builder(
          itemCount: _groupStatusController.groups.length,
          itemBuilder: (context, index) {
            final group = _groupStatusController.groups[index];
            return ListTile(
              title: Text(group.name),
              subtitle:
                  Text('Members: ${group.memberCount}'), // Display member count
              onTap: () {
                // Navigate to the chat page for this group
                Get.to(() => ChatPage(
                      chatRoomID: group.groupID,
                      chatRoomName: group.name,
                      memberIDs: [], // You can pass memberIDs if needed
                    ));
              },
            );
          },
        );
      }),
    );
  }
}
