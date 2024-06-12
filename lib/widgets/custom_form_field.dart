import 'package:flutter/material.dart';
import 'package:morning_buddies/utils/design_palette.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String emptyErrorText;

  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.emptyErrorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide(
              // style: BorderStyle.solid,
              color: ColorStyles.btnGrey,
              width: 0.5),
        ),
        hintText: hintText,
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return emptyErrorText;
        }
        return null;
      },
    );
  }
}
