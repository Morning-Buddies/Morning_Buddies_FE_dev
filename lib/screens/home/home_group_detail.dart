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
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Divider(),
          const SizedBox(height: 4),
          Container(
            width: 390,
            height: 200,
            decoration: const BoxDecoration(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
