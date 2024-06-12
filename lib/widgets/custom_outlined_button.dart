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
          mainAxisSize: MainAxisSize.min,
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

// 사용 예시
// CustomOutlinedButton(
//   width: 300,
//   text: '로그인 하기',
//   textStyle: const TextStyle(color: Colors.white),
//   onPressed: () {
//     if (_formKey.currentState!.validate()) {
//       // 로그인 로직 들어갈 자리
//     }
//   },
//   icon: const Icon(Icons.login, color: Colors.white), // 아이콘 사용 예시
// );
