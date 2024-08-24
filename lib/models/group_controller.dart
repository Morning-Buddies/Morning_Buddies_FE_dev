import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:morning_buddies/service/chat_service.dart';
import 'package:morning_buddies/service/group_service.dart';

class GroupStatus {
  final String name;
  final String time;
  final int memberCount;
  final String groupID;

  GroupStatus({
    required this.name,
    required this.time,
    required this.memberCount,
    required this.groupID,
  });
}

class GroupStatusController extends GetxController {
  var groups = <GroupStatus>[].obs;
  final ChatService _chatService = ChatService(); // Injecting ChatService
  final GroupService _groupService = GroupService(); // Injecting GroupService
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    fetchGroupsFromFirestore();
  }

  Future<void> fetchGroupsFromFirestore() async {
    final String currentUserID = _auth.currentUser!.uid;

    try {
      QuerySnapshot groupSnapshot =
          await _groupService.getGroupsForUser(currentUserID);
      groups.clear(); // Clear the local list before populating

      for (var doc in groupSnapshot.docs) {
        Map<String, dynamic> groupData = doc.data() as Map<String, dynamic>;
        List<dynamic> memberIDs = groupData['memberIDs'] ?? [];

        if (memberIDs.contains(currentUserID)) {
          groups.add(GroupStatus(
            memberCount: groupData['memberIDs'].length,
            name: groupData['name'],
            time: "Time Placeholder",
            groupID: doc.id,
          ));
        }
      }
    } catch (e) {
      print('Error fetching groups: $e');
    }
  }

  void removeGroup(GroupStatus group) {
    groups.remove(group);
  }
}
