import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morning_buddies/utils/design_palette.dart';

class SectionWithButton extends StatelessWidget {
  final String title;
  final String buttonText;
  final VoidCallback? onPressed;

  const SectionWithButton({
    super.key,
    required this.title,
    required this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _SectionTitle(title),
          _BorderedTextButton(
            buttonText,
            onPressed: onPressed,
          ),
        ],
      ),
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
  final VoidCallback? onPressed;

  const _BorderedTextButton(this.text, {super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        minimumSize: Size.zero,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        foregroundColor: ColorStyles.secondaryOrange,
        side: const BorderSide(color: ColorStyles.secondaryOrange),
      ),
      onPressed: onPressed,
      child: SizedBox(
        height: 22,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 2.0, bottom: 2.0),
              child: Text(
                text,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.arrow_forward_ios_sharp,
              size: 12,
            ),
          ],
        ),
      ),
    );
  }
}
