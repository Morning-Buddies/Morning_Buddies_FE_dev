import 'package:get/get.dart';

class GroupStatus {
  final String name;
  final String status;
  final String time;

  GroupStatus({required this.name, required this.status, required this.time});
}

class GroupStatusController extends GetxController {
  var groups = <GroupStatus>[].obs;
  void removeGroup(GroupStatus group) {
    groups.remove(group);
  }

  @override
  void onInit() {
    groups.addAll([
      GroupStatus(name: "Group 1", status: "Missed", time: "6:30 AM"),
      GroupStatus(name: "Group 2", status: "Dismissed", time: "7:00 AM"),
      GroupStatus(name: "Group 3", status: "Dismissed", time: "8:00 AM"),
    ]);
    super.onInit();
  }
}
