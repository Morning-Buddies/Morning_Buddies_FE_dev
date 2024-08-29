import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GroupService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<QuerySnapshot> getGroupsForUser(String userID) async {
    return await _firestore
        .collection("groups")
        .where("memberIDs", arrayContains: userID)
        .get();
  }

  Future<String> createOrGetGroup(String groupName, String description) async {
    String normalizedGroupName = groupName.trim().toLowerCase();

    // Check if a group with the same name already exists
    QuerySnapshot existingGroups = await _firestore
        .collection("groups")
        .where("normalizedName", isEqualTo: normalizedGroupName)
        .limit(1)
        .get();

    if (existingGroups.docs.isNotEmpty) {
      // If group exists, return its ID
      String existingGroupID = existingGroups.docs.first.id;
      print("Group '$groupName' already exists with ID: $existingGroupID");
      return existingGroupID;
    } else {
      // If no group exists, create a new one
      final String groupID = _firestore.collection("groups").doc().id;

      await _firestore.collection("groups").doc(groupID).set({
        'name': groupName,
        'normalizedName':
            normalizedGroupName, // Add normalized name for consistent querying
        'description': description,
        'memberIDs': [], // Initially, the group has no members
        'createdAt': Timestamp.now(),
      });

      print("Group '$groupName' created with ID: $groupID");
      return groupID;
    }
  }

  Future<void> joinGroup(String groupID) async {
    final String currentUserID = _auth.currentUser!.uid;

    await _firestore.collection("groups").doc(groupID).update({
      'memberIDs': FieldValue.arrayUnion([currentUserID]),
    });

    print("User $currentUserID joined group $groupID");
  }

  Future<DocumentSnapshot> getGroupByID(String groupID) async {
    return await _firestore.collection("groups").doc(groupID).get();
  }
}
