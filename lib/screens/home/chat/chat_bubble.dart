import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final String senderName;
  final String time;
  final bool isCurrentUser;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.senderName,
    required this.time,
    required this.isCurrentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Radius messageRadius = Radius.circular(15);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isCurrentUser)
            Text(
              senderName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          SizedBox(height: 3),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isCurrentUser ? Colors.blue[200] : Colors.grey[300],
              borderRadius: BorderRadius.only(
                topLeft: messageRadius,
                topRight: messageRadius,
                bottomLeft: isCurrentUser ? messageRadius : Radius.zero,
                bottomRight: isCurrentUser ? Radius.zero : messageRadius,
              ),
            ),
            child: Text(
              message,
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(height: 2),
          Text(
            time,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
