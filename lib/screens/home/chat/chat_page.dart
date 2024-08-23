import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:morning_buddies/screens/home/chat/chat_bubble.dart';
import 'package:morning_buddies/screens/home/home_chat.dart';
import 'package:morning_buddies/service/auth_service.dart';
import 'package:morning_buddies/service/chat_service.dart';
import 'package:morning_buddies/utils/design_palette.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;
  final String receiverName;

  const ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
    required this.receiverName,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverID, _messageController.text);
    }
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.receiverName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.to(HomeChat()),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: IconButton(
              icon: const Icon(Icons.call_outlined),
              onPressed: () {},
            ),
          )
        ],
      ),
      body: Column(
        children: [
          const Divider(),
          Expanded(
            child: _buildMessageList(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildUserInput(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
        stream: _chatService.getMessages(widget.receiverID, senderID),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Error");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading..");
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              controller: _scrollController,
              children: snapshot.data!.docs
                  .map((doc) => _buildMessageItem(doc))
                  .toList(),
            ),
          );
        });
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    Timestamp timestamp = data['timestamp'];
    DateTime dateTime = timestamp.toDate();
    String formattedTime = DateFormat('hh:mm a').format(dateTime);

    return Container(
        alignment: alignment,
        child: Column(
          children: [
            ChatBubble(
              message: data["message"],
              isCurrentUSer: isCurrentUser,
              time: formattedTime,
              receiverName: widget.receiverName,
            )
          ],
        ));
  }

  Widget _buildUserInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            focusNode: myFocusNode,
            controller: _messageController,
            onChanged: (text) {
              // 💡 일단 100자 제한 합니다.
              if (text.characters.length > 100) {
                _messageController.text = text.characters.take(100).toString();
              }
            },
            decoration: const InputDecoration(
              hintText: "Type a Message",
            ),
            onSubmitted: (value) {
              sendMessage();
            },
          ),
        ),
        IconButton(
          onPressed: sendMessage,
          icon: const Icon(Icons.arrow_upward),
        )
      ],
    );
  }
}
