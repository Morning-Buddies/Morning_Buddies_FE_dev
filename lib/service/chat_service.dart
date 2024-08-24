import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:morning_buddies/models/chat_room.dart';
import 'package:morning_buddies/models/message.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Creates a new chat room
  Future<void> createChatRoom(String name, List<String> memberIDs) async {
    final String chatRoomID = _firestore.collection("chat_rooms").doc().id;
    DocumentSnapshot chatRoomSnapshot =
        await _firestore.collection("chat_rooms").doc(chatRoomID).get();

    ChatRoom chatRoom = ChatRoom(
      id: chatRoomID,
      name: name,
      memberIDs: memberIDs,
      createdAt: Timestamp.now(),
    );

    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .set(chatRoom.toMap());
  }

  // Sends a message to the specified chat room
  Future<void> sendMessage({
    required String chatRoomID,
    required String senderID,
    required String message,
  }) async {
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;

    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      message: message,
      timestamp: Timestamp.now(),
      chatRoomID: chatRoomID,
    );

    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  // Fetches real-time messages for a chat room
  Stream<QuerySnapshot> getMessagesStream(String chatRoomID) {
    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  // Fetches the chat rooms that the current user is a member of
  Stream<List<ChatRoom>> getUserChatRooms(String userID) {
    return _firestore
        .collection("chat_rooms")
        .where("memberIDs", arrayContains: userID)
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          return ChatRoom.fromMap(doc.data());
        }).toList();
      },
    );
  }

  // Fetches user names based on user IDs
  Future<Map<String, String>> getUserNames(List<String> userIDs) async {
    Map<String, String> userNames = {};
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where(FieldPath.documentId, whereIn: userIDs)
          .get();

      for (var doc in snapshot.docs) {
        userNames[doc.id] = doc['displayName'] ?? 'Unknown';
      }
    } catch (e) {
      print('Error fetching user names: $e');
    }
    return userNames;
  }

  Future<void> createChatRoomForGroup(
      String groupID, String groupName, List<String> memberIDs) async {
    final String chatRoomID = groupID; // Using the group ID as the chat room ID

    DocumentSnapshot chatRoomSnapshot =
        await _firestore.collection("chat_rooms").doc(chatRoomID).get();

    if (!chatRoomSnapshot.exists) {
      await _firestore.collection("chat_rooms").doc(chatRoomID).set({
        'id': chatRoomID,
        'name': groupName,
        'memberIDs': memberIDs,
        'createdAt': Timestamp.now(),
      });

      print("Chat room created for group '$groupName'");
    } else {
      print("Chat room already exists for group '$groupName'");
      // Optionally, you can update the member list if new members have joined
      await _firestore.collection("chat_rooms").doc(chatRoomID).update({
        'memberIDs': FieldValue.arrayUnion(memberIDs),
      });
    }
  }
}
