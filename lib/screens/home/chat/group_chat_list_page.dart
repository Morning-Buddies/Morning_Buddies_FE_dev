import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morning_buddies/models/groupchat_controller.dart';
import 'package:morning_buddies/screens/home/chat/chat_page.dart';

class GroupChatListPage extends StatelessWidget {
  GroupChatListPage({super.key});
  final GroupChatStatusController _groupStatusController =
      Get.put(GroupChatStatusController());

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    String currentUserId = auth.currentUser!.uid;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Chat Rooms'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _groupStatusController.fetchGroupsFromFirestore();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (_groupStatusController.chatRooms.isEmpty) {
          return const Center(child: Text('No groups found.'));
        }
        return ListView.builder(
          itemCount: _groupStatusController.chatRooms.length,
          itemBuilder: (context, index) {
            final chatRooms = _groupStatusController.chatRooms[index];
            return ListTile(
              title: Text(chatRooms.name),
              trailing: chatRooms.leaderId == currentUserId
                  ? const Icon(Icons.supervised_user_circle)
                  : null,
              subtitle: Text(
                  'Members: ${chatRooms.memberCount}'), // Display member count
              onTap: () {
                // Navigate to the chat page for this group
                Get.to(() => ChatPage(
                      chatRoomID: chatRooms.groupID,
                      chatRoomName: chatRooms.name,
                      leaderID: chatRooms.leaderId,
                      memberIDs: chatRooms
                          .memberIDs, // You can pass memberIDs if needed
                    ));
              },
            );
          },
        );
      }),
    );
  }
}
