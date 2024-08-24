import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  final String id;
  final String name;
  final List<String> memberIDs;
  final Timestamp createdAt;

  ChatRoom({
    required this.id,
    required this.name,
    required this.memberIDs,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'memberIDs': memberIDs,
      'createdAt': createdAt,
    };
  }

  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      id: map['id'] as String,
      name: map['name'] as String,
      memberIDs: List<String>.from(map['memberIDs']),
      createdAt: map['createdAt'] as Timestamp,
    );
  }
}


/* 
FIREBASE DATA 구조

chat_rooms (Collection)
  |
  |-- chatRoomID (Document)
  |     |-- name: "Group Chat Name"
  |     |-- memberIDs: ["userID1", "userID2", "userID3"]
  |     |-- createdAt: Timestamp
  |     |
  |     |-- messages (Subcollection)
  |           |-- messageID (Document)
  |                 |-- senderID: "userID"
  |                 |-- senderEmail: "user@example.com"
  |                 |-- message: "Hello!"
  |                 |-- timestamp: Timestamp 
  
  */