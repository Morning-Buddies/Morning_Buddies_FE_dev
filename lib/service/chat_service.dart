import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:morning_buddies/models/message.dart';

class ChatService {
  // Firestore의 Instance 가져오기
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // User Stream 가져오기
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  // 메시지 전송
  Future<void> sendMessage(String receiverID, message) async {
    // 현재 접속중인 사용자 정보
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();
    // 새로운 메시지

    Message newMessage = Message(
        senderID: currentUserID,
        senderEmail: currentUserEmail,
        receiverID: receiverID,
        message: message,
        timestamp: timestamp);

    // 두 유저간 채팅 방 아이디
    List<String> ids = [currentUserID, receiverID];
    ids.sort(); // 정렬 통해 2명에게 같은 아이디 발급
    String chatRoomID = ids.join('_');

    // 데베에 메시지 추가
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }
  // 메시지 수신

  Stream<QuerySnapshot> getMessages(String userID, otherUSerID) {
    List<String> ids = [userID, otherUSerID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
