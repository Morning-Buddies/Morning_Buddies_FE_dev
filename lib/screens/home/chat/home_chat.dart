import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:morning_buddies/models/chat_room.dart';
import 'package:morning_buddies/screens/home/chat/chat_page.dart';
import 'package:morning_buddies/service/auth_service.dart';
import 'package:morning_buddies/service/chat_service.dart';
import 'package:get/get.dart';

class HomeChat extends StatelessWidget {
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  HomeChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Rooms'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Code to create a new chat room, e.g., show a dialog to enter room name and add members
            },
          ),
        ],
      ),
      body: _buildChatRoomList(),
    );
  }

  Widget _buildChatRoomList() {
    String currentUserID = _authService.getCurrentUser()!.uid;

    return StreamBuilder(
      stream: _chatService.getUserChatRooms(currentUserID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Error loading chat rooms"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No chat rooms found"));
        }

        return ListView(
          children: snapshot.data!
              .map<Widget>((chatRoom) => _buildChatRoomItem(chatRoom))
              .toList(),
        );
      },
    );
  }

  Widget _buildChatRoomItem(ChatRoom chatRoom) {
    return ListTile(
      title: Text(chatRoom.name),
      subtitle: Text("Members: ${chatRoom.memberIDs.length}"),
      onTap: () {
        Get.to(
          () => ChatPage(
            chatRoomID: chatRoom.id,
            chatRoomName: chatRoom.name,
            memberIDs: chatRoom.memberIDs,
          ),
        );
      },
    );
  }
}
