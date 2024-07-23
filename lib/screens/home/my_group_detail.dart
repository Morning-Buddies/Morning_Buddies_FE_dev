import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class MyGroupDetail extends StatefulWidget {
  const MyGroupDetail({super.key});

  @override
  State<MyGroupDetail> createState() => _MyGroupDetailState();
}

class _MyGroupDetailState extends State<MyGroupDetail> {
  /* 
    💡 현재 List<GroupList> 를 받아오면 됨,
    다만, 기본 데이터 타입과 Map형태만을 지원하기에 직렬화가 필요
  */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
