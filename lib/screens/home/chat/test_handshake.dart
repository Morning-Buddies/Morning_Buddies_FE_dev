import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:morning_buddies/auth/auth_controller.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  String? serverUrl = dotenv.env["WEBSOCKET_API_KEY"];
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];
  WebSocket? _socket;
  final AuthController _authController = Get.find<AuthController>();
  bool _isReconnecting = false;

  @override
  void initState() {
    super.initState();
    connectToWebSocket(fakeToken: true); // 초기 fakeAccessToken 사용
  }

  Future<void> connectToWebSocket({bool fakeToken = false}) async {
    String? accessToken = _authController.accessToken;

    if (!fakeToken && (accessToken == null || accessToken.isEmpty)) {
      await _handleTokenRefresh();
      accessToken = _authController.accessToken;
      if (accessToken == null) {
        setState(() {
          _messages.add("Unable to refresh token. Please log in.");
        });
        return;
      }
    }

    final uri = Uri.parse("$serverUrl/1/1");

    try {
      // HTTP handshake to check status code
      final request = await HttpClient().openUrl('GET', uri);
      request.headers.set('Authorization', 'Bearer $accessToken');

      final response = await request.close();
      if (response.statusCode == 401 || response.statusCode == 403) {
        print("Access token might be expired. Refreshing...");
        if (!_isReconnecting) {
          _isReconnecting = true;
          await _handleTokenRefresh();
          _isReconnecting = false;
          connectToWebSocket(); // 갱신 후 재연결
        }
        return;
      } else if (response.statusCode != 101) {
        print("Unexpected status code: ${response.statusCode}");
        setState(() {
          _messages.add("Unexpected status code: ${response.statusCode}");
        });
        return;
      }

      // WebSocket connection after successful handshake
      _socket = await WebSocket.connect(
        uri.toString(),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      print("WebSocket connected successfully");
      setState(() {
        _messages.add("Connected to WebSocket.");
      });

      _socket!.listen(
        (message) {
          setState(() {
            _messages.add("Received: $message");
          });
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

  int _tokenRefreshAttempts = 0;
  final int _maxRefreshAttempts = 3;

  Future<void> _handleTokenRefresh() async {
    if (_tokenRefreshAttempts >= _maxRefreshAttempts) {
      setState(() {
        _messages.add("Failed to refresh token. Please log in again.");
      });
      return;
    }

    _tokenRefreshAttempts++;
    final refreshToken = _authController.refreshToken;

    if (refreshToken != null) {
      final success = await _authController.refreshAccessToken(refreshToken);
      if (success) {
        _tokenRefreshAttempts = 0; // Reset attempts on success
        connectToWebSocket();
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
