import 'package:flutter/material.dart';
import 'package:morning_buddies/utils/design_palette.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUSer;
  final String time;
  final String receiverName;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUSer,
    required this.time,
    required this.receiverName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 18,
                child: Icon(Icons.person), // 추후 개인별 이미지로 변경 예정
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          isCurrentUSer ? "Me" : receiverName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          time,
                          style: const TextStyle(color: ColorStyles.btnGrey),
                        )
                      ],
                    ),
                    Text(
                      message,
                      softWrap: true,
                      maxLines: null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
