import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:morning_buddies/auth/firebase_auth_service.dart';
import 'package:morning_buddies/service/chat_service.dart';

import 'chat_bubble.dart';

class ChatPage extends StatefulWidget {
  final String chatRoomID;
  final String chatRoomName;
  final String leaderID;
  final List<String> memberIDs;

  const ChatPage({
    Key? key,
    required this.chatRoomID,
    required this.chatRoomName,
    required this.leaderID,
    required this.memberIDs,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  final ScrollController _scrollController = ScrollController();

  Map<String, String> _memberNames = {};
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = _authService.getCurrentUser();
    _fetchMemberNames();
  }

  Future<void> _fetchMemberNames() async {
    Map<String, String> names =
        await _chatService.getUserNames(widget.memberIDs);
    setState(() {
      _memberNames = names;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatRoomName),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showChatRoomInfo,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _chatService.getMessagesStream(widget.chatRoomID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading messages'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
              child: Text('No messages yet. Start the conversation!'));
        }
        return ListView(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final bool isCurrentUser = data['senderID'] == _currentUser?.uid;
    final String senderName = _memberNames[data['senderID']].toString();
    final DateTime timestamp = (data['timestamp'] as Timestamp).toDate();
    final String formattedTime = DateFormat('hh:mm a').format(timestamp);

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ChatBubble(
        message: data['message'],
        senderName: senderName,
        time: formattedTime,
        isCurrentUser: isCurrentUser,
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      color: Colors.grey[200],
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              textInputAction: TextInputAction.send,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            onPressed: _sendMessage,
            mini: true,
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    final String messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    _messageController.clear();

    await _chatService.sendMessage(
      chatRoomID: widget.chatRoomID,
      senderID: _currentUser!.uid,
      message: messageText,
    );

    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _showChatRoomInfo() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.chatRoomName,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Members:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 5),
              ..._memberNames.entries.map((entry) => ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(entry.value),
                  )),
            ],
          ),
        );
      },
    );
  }
}
