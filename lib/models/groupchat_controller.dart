import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GroupChatStatus {
  final String name;
  final String time;
  final String leaderId;
  final int memberCount;
  final List<String> memberIDs;
  final String groupID;

  GroupChatStatus({
    required this.name,
    required this.time,
    required this.leaderId,
    required this.memberIDs,
    required this.memberCount,
    required this.groupID,
  });
}

class GroupChatStatusController extends GetxController {
  var chatRooms = <GroupChatStatus>[].obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    fetchGroupsFromFirestore();
  }

  Future<void> fetchGroupsFromFirestore() async {
    final String currentUserID = _auth.currentUser!.uid;

    try {
      // 최적화된 쿼리: 현재 사용자가 포함된 그룹만 가져옴
      QuerySnapshot groupSnapshot = await FirebaseFirestore.instance
          .collection('chat_rooms')
          .where('memberIDs', arrayContains: currentUserID)
          .get();

      chatRooms.clear(); // Clear the local list before populating

      for (var doc in groupSnapshot.docs) {
        Map<String, dynamic> groupData = doc.data() as Map<String, dynamic>;
        print('Fetched group data: $groupData');

        // 명확히 List<String>으로 캐스팅
        List<String> memberIDs =
            List<String>.from(groupData['memberIDs'] ?? []);

        chatRooms.add(GroupChatStatus(
          memberCount: memberIDs.length,
          memberIDs: memberIDs,
          leaderId: groupData['leaderId'],
          name: groupData['name'] ?? 'Unknown Group', // 기본 값 추가
          time: "Time Placeholder", // 실제 시간을 여기에 추가할 수 있음
          groupID: doc.id,
        ));
      }
    } catch (e) {
      print('Error fetching groups: $e');
    }
  }

  void removeGroup(GroupChatStatus group) {
    // GetX 가 관리하는 데이터에서만 Remove, DB에서도 Remove 필요
    chatRooms.remove(group);
  }
}
