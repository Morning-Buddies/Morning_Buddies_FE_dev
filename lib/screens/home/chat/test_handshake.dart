import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morning_buddies/auth/auth_controller.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];
  WebSocket? _socket;

  final AuthController _authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    connectToWebSocket();
  }

  void connectToWebSocket() async {
    String? accessToken = _authController.accessToken;
    const fakeAccessToken = "fake_or_expired_access_token";

    if (accessToken == null || accessToken.isEmpty) {
      print("Access Token is missing. Attempting to refresh...");
      final refreshToken = _authController.refreshToken;
      print("Initial Refresh Token: $refreshToken");

      if (refreshToken != null) {
        final success = await _authController.refreshAccessToken(refreshToken);
        print("Refresh Token Success: $success");

        if (success) {
          accessToken = _authController.accessToken;
          print("Access Token refreshed successfully: $accessToken");
        } else {
          setState(() {
            _messages.add("Unable to refresh token. Please log in again.");
          });
          return;
        }
      } else {
        setState(() {
          _messages.add("No refresh token available. Please log in.");
        });
        return;
      }
    }

    try {
      print("Connecting to WebSocket...");
      _socket = await WebSocket.connect(
        "wss://dev.morningbuddies.shop/chat/1/1",
        headers: {
          'Authorization': 'Bearer $fakeAccessToken',
        },
      );

      print("WebSocket connected successfully");

      _socket!.listen(
        (message) {
          setState(() {
            _messages.add("Received: $message");
          });
        },
        onError: (error) {
          print("WebSocket Error: $error"); // 오류 출력
          if (error.toString().contains("401") ||
              error.toString().contains("403")) {
            print("Access token might be expired. Refreshing...");
            _handleTokenRefresh(); // 갱신 로직 처리
          } else {
            setState(() {
              _messages.add("WebSocket Error: $error");
            });
          }
        },
        onDone: () {
          print("WebSocket connection closed.");
          setState(() {
            _messages.add("WebSocket connection closed.");
          });
        },
      );
    } catch (e, stacktrace) {
      print("WebSocket Connection Error: $e");
      print("Stack Trace: $stacktrace");
      setState(() {
        _messages.add("Connection Error: $e");
      });
    }
  }

  Future<void> _handleTokenRefresh() async {
    final refreshToken = _authController.refreshToken;
    if (refreshToken != null) {
      final success = await _authController.refreshAccessToken(refreshToken);
      if (success) {
        connectToWebSocket(); // 토큰 갱신 성공 후 재연결
      } else {
        setState(() {
          _messages.add("Failed to refresh token. Please log in again.");
        });
      }
    } else {
      setState(() {
        _messages.add("No refresh token available. Please log in.");
      });
    }
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty && _socket != null) {
      final message = {
        "action": "sendMessage",
        "message": {
          "message": _controller.text,
          "time": DateTime.now().toIso8601String(),
        },
      };
      _socket!.add(jsonEncode(message));
      setState(() {
        _messages.add("Sent: ${_controller.text}");
        _controller.clear();
      });
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
        title: const Text("WebSocket Test"),
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
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_messages[index]),
                  );
                },
              ),
            ),
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
