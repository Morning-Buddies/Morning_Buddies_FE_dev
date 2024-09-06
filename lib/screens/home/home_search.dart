import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morning_buddies/models/groupinfo_controller.dart';

class HomeSearch extends StatefulWidget {
  const HomeSearch({super.key});

  @override
  State<HomeSearch> createState() => _HomeSearchState();
}

class _HomeSearchState extends State<HomeSearch> {
  final TextEditingController _searchController = TextEditingController();
  bool _showHintText = true;
  final GroupinfoController _groupinfoController =
      Get.put(GroupinfoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText:
                _showHintText ? "Search by wake-up time or interest" : null,
            hintStyle: const TextStyle(fontSize: 12),
            filled: true,
            fillColor: const Color(0xFFefeff0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40.0),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          onChanged: (value) {
            setState(() {
              _showHintText = value.isEmpty;
            });
          },
          onSubmitted: (value) {
            _groupinfoController.search(value.toLowerCase());
          },
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 16.0),
            child: Text(
              'Recommendations',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildRecommendationButton('러닝'),
                _buildRecommendationButton('아침 헬스'),
                _buildRecommendationButton('출근러'),
                _buildRecommendationButton('간헐적 단식'),
                _buildRecommendationButton('오전 6시'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Display search results
          Expanded(
            child: Obx(() {
              if (_groupinfoController.results.isEmpty) {
                return const Center(
                  child: Text('No results found'),
                );
              } else {
                return ListView.builder(
                  itemCount: _groupinfoController.results.length,
                  itemBuilder: (context, index) {
                    final group = _groupinfoController.results[index];
                    return ListTile(
                      title: Text(group.group_name),
                      subtitle: Text('Wake-up Time: ${group.wake_up_time}'),
                    );
                  },
                );
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationButton(String text) {
    // 💡 검색창에 인풋이 들어왔다가 지워져도 다시 나타나야 함
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: ElevatedButton(
        onPressed: () {
          _groupinfoController.search(text.toLowerCase());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0.1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        child: Text(text),
      ),
    );
  }
}
