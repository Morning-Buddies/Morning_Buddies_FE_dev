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

  // Method to create or get an existing group
  Future<String> createOrGetGroup(String groupName, String description) async {
    // Normalize the group name to ensure consistent matching (e.g., trim and lowercase)
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
      return groupID; // Return the group ID for further operations
    }
  }

  // Method to join a group
  Future<void> joinGroup(String groupID) async {
    final String currentUserID = _auth.currentUser!.uid;

    await _firestore.collection("groups").doc(groupID).update({
      'memberIDs': FieldValue.arrayUnion([currentUserID]),
    });

    print("User $currentUserID joined group $groupID");
  }

  // Method to fetch a group by ID
  Future<DocumentSnapshot> getGroupByID(String groupID) async {
    return await _firestore.collection("groups").doc(groupID).get();
  }
}
