import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  final double width;
  final String text;
  final TextStyle textStyle;
  final VoidCallback onPressed;
  final Image? icon;
  final Color backgroundcolor;

  const CustomOutlinedButton({
    Key? key,
    required this.width,
    required this.text,
    required this.textStyle,
    required this.onPressed,
    required this.backgroundcolor,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundcolor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          side: BorderSide.none,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: 16), // 아이콘과 텍스트 사이의 간격
            ],
            Text(
              text,
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}
