import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomeWebsocket extends StatefulWidget {
  const HomeWebsocket({super.key});

  @override
  State<HomeWebsocket> createState() => _HomeWebsocketState();
}

class _HomeWebsocketState extends State<HomeWebsocket> {
  late final TextEditingController _textEditingController;
  // WebSocket 웹소켓 채널을 선언
  late final WebSocketChannel channel;

  @override
  void initState() {
    // 텍스트 입력 컨트롤러를 초기화
    _textEditingController = TextEditingController();
    //WebSocket 웹소켓 서버 연결
    channel = IOWebSocketChannel.connect(
        Uri.parse('wss://dev.morningbuddies/ws-stomp'));
    super.initState();
  }

  @override
  void dispose() {
    // 텍스트 입력 컨트롤러 해제
    _textEditingController.dispose();
    // WebSocket 채널 통신 닫기
    channel.sink.close();
    super.dispose();
  }

  void _onPressed() {
    // WebSocket 채널을 통해 메시지를 보내기
    channel.sink.add(_textEditingController.text);
    // 텍스트 필드를 초기화
    _textEditingController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("웹소켓 서버 송신 테스트"),
      ),
      body: Center(
        child: SizedBox(
          height: 500,
          child: Column(
            children: [
              TextField(
                controller: _textEditingController,
              ),
              // StreamBuilder로 WebSocket 스트림을 감시
              StreamBuilder(
                stream: channel.stream,
                builder: (context, snapshot) {
                  //수신할 데이터가 있으면 표시하고, 없으면 빈 문자열을 표시
                  return Text(
                    snapshot.hasData ? '${snapshot.data}' : '',
                    style: const TextStyle(fontSize: 20),
                  );
                },
              ),
              // 버튼 클릭 시 _onPressed를 호출하여 웹소켓에 Text 송신
              TextButton(onPressed: _onPressed, child: const Text("Send"))
            ],
          ),
        ),
      ),
    );
  }
}
