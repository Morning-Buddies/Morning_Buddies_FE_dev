import 'package:flutter/material.dart';

class HomeGroupDetail extends StatefulWidget {
  const HomeGroupDetail({super.key});

  @override
  State<HomeGroupDetail> createState() => _HomeGroupDetailState();
}

class _HomeGroupDetailState extends State<HomeGroupDetail> {
  bool isJoined = false;

  // Home이나 Search 결과로 나오는 불특정다수 group 정보들에 대해선 getX 미사용으로 결정
  // getX로 관리하는 데이터는 "개인" 유저와 관련된 것들만 하기로.
  // 비록 검색 결과로 나온 group을 클릭해서 already-joined 일지라도 그건 해당 페이지에서만 사용하는 값이기 때문에 api로 필터링하지 않고 front에서 setState로 판단해서 ui 보여주기로.
  void _joinGroup() {
    setState(() {
      isJoined = true;
    });
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('Move to Group-Chat'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to group chat
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Leave Group'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  isJoined = false;
                });
                // Handle group leaving
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            const SizedBox(height: 4),
            Container(
              width: 390,
              height: 200,
              decoration: const BoxDecoration(color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '출근 전 헬스',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Image(
                        image: AssetImage('assets/images/logo_solo-bird.png'),
                        height: 20,
                      ),
                      SizedBox(width: 8),
                      Text('현재 4명'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.orange),
                      SizedBox(width: 8),
                      Text('7:00 AM'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '갓생 살고 싶은 판교 직장인들 함께 해요:)\n<필독>\n1. 3번 이상 실패시 강퇴\n2. 홍보/욕설금지',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 36),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Members',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '4 / 10 members',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // group 정보 DB에서 가져와야함
                  const Column(
                    children: [
                      MemberTile(name: '조완기'),
                      MemberTile(name: '백태균'),
                      MemberTile(name: '박동규'),
                      MemberTile(name: '박찬주'),
                    ],
                  ),
                  const SizedBox(height: 36),
                  if (isJoined)
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: const Icon(Icons.more_vert, color: Colors.black),
                        onPressed: _showOptionsMenu,
                      ),
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _joinGroup,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: const Text(
                          'Newly Join to be a Newbie!',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MemberTile extends StatelessWidget {
  final String name;

  const MemberTile({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage('assets/avatar_placeholder.png'),
          ),
          const SizedBox(width: 16),
          Text(
            name,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
