import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:morning_buddies/auth/token_manager.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final TextEditingController _controller = TextEditingController();
  WebSocket? _socket;
  String websocketAddress = dotenv.env["WEB_SOCKET_ADDRESS"]!;

  @override
  void initState() {
    super.initState();
    connectToWebSocket();
  }

  void connectToWebSocket() async {
    final accessToken = await TokenManager().getAccessToken();

    try {
      // Retrieve the access token from secure storage

      if (accessToken == null || accessToken.isEmpty) {
        print("Access token is missing. Unable to connect.");
        return;
      }

      _socket = await WebSocket.connect(
        "$websocketAddress/1/1",
        headers: {
          'Authorization': 'Bearer $accessToken', // the access token
        },
      );

      _socket!.listen(
        (message) {
          setState(() {
            print("Received: $message");
          });
        },
        onError: (error) {
          print("Error: $error");
        },
        onDone: () {
          print("Connection closed.");
        },
      );
    } catch (e) {
      print("WebSocket Connection Error: $e");
    }
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty && _socket != null) {
      // JSON 형식으로 메시지 구성
      final message = {
        "action": "sendMessage",
        "message": {
          "message": _controller.text,
          "time": DateTime.now().toIso8601String(), // 현재 시간을 ISO 형식으로
        },
      };

      // JSON 문자열로 변환 후 전송
      _socket!.add(jsonEncode(message));
    }
  }

  @override
  void dispose() {
    _socket?.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HandShake TEST"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(labelText: 'Send a message'),
              ),
            ),
            const SizedBox(height: 24),
            // 메시지 출력 위젯 추가 가능
            // 예: 수신된 데이터를 표시하는 부분을 추가할 수 있습니다.
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: const Icon(Icons.send),
      ),
    );
  }
}
