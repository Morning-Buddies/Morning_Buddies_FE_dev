import 'package:flutter/material.dart';
import 'package:morning_buddies/utils/design_palette.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String emptyErrorText;
  final String? Function(String?)? validator;
  final bool obscuretext;
  final ValueChanged<String>? onChanged;
  final TextInputAction textInputAction;
  final int? maxLength;

  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.emptyErrorText,
    this.maxLength,
    this.validator,
    this.obscuretext = false,
    this.onChanged,
    this.textInputAction = TextInputAction.next,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength,
      controller: controller,
      obscureText: obscuretext,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: const OutlineInputBorder(
          borderSide:
              BorderSide(color: ColorStyles.lightGray), // Default border color
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
              color: ColorStyles.lightGray), // Border color when not focused
        ),
        hintText: hintText,
      ),
      onChanged: onChanged,
      validator: (String? value) {
        if (validator != null) {
          return validator!(value);
        }
        return null;
      },
    );
  }
}
