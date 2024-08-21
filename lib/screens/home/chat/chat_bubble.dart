import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:morning_buddies/utils/design_palette.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUSer;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUSer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color:
              isCurrentUSer ? ColorStyles.orange : ColorStyles.secondaryYellow,
          borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Text(message),
    );
  }
}
