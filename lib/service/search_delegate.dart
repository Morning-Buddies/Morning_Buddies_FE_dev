import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morning_buddies/models/groupinfo_controller.dart';

class GroupSearchDelegate extends SearchDelegate<GroupInfoStatus> {
  GroupSearchDelegate();
  final GroupinfoController _groupinfoController =
      Get.put(GroupinfoController());

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        Get.toNamed('/main');
      },
      icon: const Icon(Icons.arrow_back_ios),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }
}
