import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeChat extends StatefulWidget {
  const HomeChat({super.key});

  @override
  State<HomeChat> createState() => _HomeChatState();
}

class _HomeChatState extends State<HomeChat> {
  final _controller = TextEditingController();
  final _auth = FirebaseAuth.instance;
  User? loggedInUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  // 현재 접속 유저 확인
  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        setState(() {
          loggedInUser = user;
        });
        print(loggedInUser!.phoneNumber);
      }
    } catch (e) {
      print(e);
    }
  }

  // 채팅기능 추가
  void _sendMessage() {
    _controller.text = _controller.text.trim();
    if (_controller.text.isEmpty) {
      FirebaseFirestore.instance.collection('chats').add({
        'text': _controller.text,
        'sender': loggedInUser!.phoneNumber,
        'timestamp': Timestamp.now(),
      });
      _controller.clear();
    } else if (loggedInUser == null) {
      // Handle the case where the user is not logged in
      print('User not logged in. Unable to send message.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Group Name"),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final chatDocs = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: chatDocs.length,
                  itemBuilder: (context, index) {
                    bool isMe =
                        chatDocs[index]['sender'] == loggedInUser!.phoneNumber;
                    return Row(
                      mainAxisAlignment: isMe
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal:
                                  16), // 컨테이너 내부의 위젯들에 대해 수직 및 수평 방향으로 패딩을 적용
                          margin: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal:
                                  8), // 컨테이너 외부의 공간에 대해 수직 및 수평 방향으로 마진을 설정
                          decoration: BoxDecoration(
                            color: isMe
                                ? Colors.grey[300]
                                : Colors.grey[
                                    500], // 메시지가 현재 사용자에 의해 보내진 경우 밝은 회색, 아닐 경우 더 어두운 회색
                            borderRadius: isMe
                                ? const BorderRadius.only(
                                    topLeft: Radius.circular(
                                        14), // 현재 사용자의 메시지일 경우, 오른쪽 아래 모서리를 제외한 모든 모서리를 둥글게 처리
                                    topRight: Radius.circular(14),
                                    bottomLeft: Radius.circular(14),
                                  )
                                : const BorderRadius.only(
                                    topLeft: Radius.circular(
                                        14), // 다른 사용자의 메시지일 경우, 오른쪽 위 모서리를 제외한 모든 모서리를 둥글게 처리
                                    topRight: Radius.circular(14),
                                    bottomRight: Radius.circular(14),
                                  ),
                          ),
                          child: Text(
                            chatDocs[index]
                                ['text'], // Firestore에서 가져온 메시지 텍스트를 표시
                            style:
                                const TextStyle(fontSize: 16), // 메시지 텍스트의 스타일
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0), // 이 위젯 전체에 대해 모든 방향으로 20.0의 패딩
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller, // 텍스트 입력을 위한 TextEditingController
                    decoration: const InputDecoration(
                        labelText: 'Send a message...'), // 입력 필드에 레이블 텍스트를 표시
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send), // 'send' 아이콘을 가진 버튼을 생성
                  onPressed: _sendMessage, // 아이콘 버튼을 누르면 _sendMessage 함수가 호출
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
