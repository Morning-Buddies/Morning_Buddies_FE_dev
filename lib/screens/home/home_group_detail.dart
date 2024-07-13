import 'package:flutter/material.dart';

class HomeGroupDetail extends StatefulWidget {
  const HomeGroupDetail({super.key});

  @override
  State<HomeGroupDetail> createState() => _HomeGroupDetailState();
}

class _HomeGroupDetailState extends State<HomeGroupDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("My Groups"),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
