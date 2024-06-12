import 'package:flutter/material.dart';

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
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.zero),
          borderSide: BorderSide(
            color: Color(0xFFABABB5),
          ),
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
