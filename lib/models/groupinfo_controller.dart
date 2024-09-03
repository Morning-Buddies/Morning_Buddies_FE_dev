import 'dart:convert'; // jsonDecode를 사용하기 위해 필요합니다.
import 'dart:ffi';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class GroupInfoStatus {
  final int group_id;
  final String group_name;
  final String description;
  final String wake_up_time;
  final bool is_activated;
  final int success_count;
  final int current_participants;
  final int max_participants;

  GroupInfoStatus({
    required this.group_id,
    required this.group_name,
    required this.description,
    required this.wake_up_time,
    required this.is_activated,
    required this.success_count,
    required this.current_participants,
    required this.max_participants,
  });

  factory GroupInfoStatus.fromJson(Map<String, dynamic> json) {
    return GroupInfoStatus(
      group_id: json['group_id'],
      group_name: json['group_name'],
      description: json['description'],
      wake_up_time: json['wake_up_time'],
      is_activated: json['is_activated'],
      success_count: json['success_count'],
      current_participants: json['current_participants'],
      max_participants: json['max_participants'],
    );
  }
}

class GroupinfoController extends GetxController {
  var getResponse = <GroupInfoStatus>[].obs;
  String baseUrl = dotenv.env["PROJECT_API_KEY"]!;

  @override
  void onInit() {
    super.onInit();
    _fetchGroupData();
  }

  Future<void> _fetchGroupData() async {
    final response = await http.get(Uri.parse("$baseUrl/groups"));
    if (response.statusCode == 200) {
      try {
        List<dynamic> jsonData = jsonDecode(response.body);
        getResponse.value =
            jsonData.map((item) => GroupInfoStatus.fromJson(item)).toList();
      } catch (e) {
        print("Error parsing JSON: $e");
      }
    } else {
      throw Exception("Failed to fetch");
    }
  }

  Future<void> _getGroupMember(Long groupId) async {
    final response = await http.get(Uri.parse("$baseUrl/groups/{$groupId}"));
    if (response.statusCode == 200) {
      try {
        // Group Member get
        // group_id 로 member 테이블에 접근할 것
      } catch (e) {
        throw Exception("could not get group member");
      }
    }
  }
}
