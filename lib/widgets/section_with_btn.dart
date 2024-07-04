import 'package:flutter/material.dart';
import 'package:morning_buddies/utils/design_palette.dart';

class SectionWithButton extends StatelessWidget {
  final String title;
  final String buttonText;
  final VoidCallback? onPressed; // 버튼 클릭 시 호출될 함수 (옵션)

  const SectionWithButton({
    super.key,
    required this.title,
    required this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _SectionTitle(title),
        _BorderedTextButton(buttonText, onPressed: onPressed), // onPressed 전달
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _BorderedTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // 버튼 클릭 시 호출될 함수 (옵션)

  const _BorderedTextButton(this.text, {super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      style: ButtonStyle(
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: const BorderSide(color: ColorStyles.secondaryOrange),
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: ColorStyles.secondaryOrange,
              fontSize: 12,
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_right,
            color: ColorStyles.secondaryOrange,
            size: 16.0,
          ),
        ],
      ),
    );
  }
}
