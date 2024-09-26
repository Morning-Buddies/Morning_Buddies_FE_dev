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

  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.emptyErrorText,
    this.validator,
    this.obscuretext = false,
    this.onChanged,
    this.textInputAction = TextInputAction.next,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscuretext,
      textInputAction: textInputAction,
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
