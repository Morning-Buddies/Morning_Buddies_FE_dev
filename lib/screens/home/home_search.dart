import 'package:flutter/material.dart';

class HomeSearch extends StatefulWidget {
  const HomeSearch({super.key});

  @override
  State<HomeSearch> createState() => _HomeSearchState();
}

class _HomeSearchState extends State<HomeSearch> {
  final TextEditingController _searchController = TextEditingController();
  bool _showHintText = true;

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
              // 검색 API Logic
            });
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
            // 버튼 스크롤 가능하도록 설정
            scrollDirection: Axis.horizontal, // 가로 스크롤
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
        ],
      ),
    );
  }

  Widget _buildRecommendationButton(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0), // 버튼 간격
      child: ElevatedButton(
        onPressed: () {}, // 버튼 클릭 시 동작 정의
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white, // 버튼 배경색
          foregroundColor: Colors.black,
          elevation: 0.1, // 버튼 글자색
          shape: RoundedRectangleBorder(
            // 버튼 모양 둥글게
            borderRadius: BorderRadius.circular(50.0),
          ),
          padding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 8), // 버튼 내부 패딩
        ),
        child: Text(text),
      ),
    );
  }
}
