import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/route_manager.dart';
import 'package:morning_buddies/screens/home/chat/chat_page.dart';
import 'package:morning_buddies/service/auth_service.dart';
import 'package:morning_buddies/service/chat_service.dart';
import 'package:morning_buddies/widgets/home_bottom_nav.dart';
import 'package:morning_buddies/widgets/user_tile.dart';
import 'package:get/get.dart';

class HomeChat extends StatelessWidget {
  HomeChat({super.key});

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: const Text('Chat Room'),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.to(const HomeBottomNav()),
          )),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    if (userData["email"] != _authService.getCurrentUser()!.email) {
      return UserTile(
        text: "${userData["lastname"]} ${userData["firstname"]}",
        onTap: () {
          Get.to(
            () => ChatPage(
              receiverEmail: userData["email"],
              receiverName: "${userData["lastname"]} ${userData["firstname"]}",
              receiverID: userData["uid"],
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
