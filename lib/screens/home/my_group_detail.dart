import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:morning_buddies/models/group_controller.dart';

class MyGroupDetail extends StatefulWidget {
  const MyGroupDetail({super.key});

  @override
  State<MyGroupDetail> createState() => _MyGroupDetailState();
}

class _MyGroupDetailState extends State<MyGroupDetail> {
  final GroupStatusController groupStatusController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
        ),
        body: Obx(() {
          return ListView.builder(
              itemCount: groupStatusController.groups.length,
              itemBuilder: (context, index) {
                final group = groupStatusController.groups[index];
                return ListTile(
                  title: Text(group.name),
                  subtitle:
                      Text('Status: ${group.status} | Time: ${group.time}'),
                );
              });
        }));
  }
}
