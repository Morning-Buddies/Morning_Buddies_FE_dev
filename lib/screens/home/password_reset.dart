import 'package:flutter/material.dart';
import 'package:morning_buddies/utils/design_palette.dart';
import 'package:morning_buddies/utils/validator.dart';
import 'package:morning_buddies/widgets/custom_form_field.dart';
import 'package:morning_buddies/widgets/custom_outlined_button.dart';

class PasswordReset extends StatefulWidget {
  const PasswordReset({super.key});

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPwController = TextEditingController();
  final TextEditingController _resetPwController = TextEditingController();
  final TextEditingController _checkPwController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Password Reset",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          const ListTile(
            title: Text(
              "Current PassWord",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomTextFormField(
              controller: _currentPwController,
              hintText: "Write down your current Password",
              emptyErrorText: "",
              // validator: Validator.validatePassword,
              // 추후 DB내 PW와 동일한 PW인지 파악하는 validator만들 예정
            ),
          ),
          const ListTile(
            title: Text(
              "Reset PassWord",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CustomTextFormField(
                  controller: _resetPwController,
                  hintText: "new Password",
                  emptyErrorText: "",
                  validator: Validator.validatePassword,
                ),
                const SizedBox(height: 4),
                CustomTextFormField(
                    controller: _checkPwController,
                    hintText: "new Password Doublecheck",
                    emptyErrorText: "",
                    validator: (value) => Validator.confirmPassword(
                        value, _resetPwController.text)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomOutlinedButton(
              backgroundcolor: ColorStyles.secondaryOrange,
              width: 374,
              text: 'Change All Set',
              textStyle: const TextStyle(color: Colors.white),
              onPressed: () {
                _formKey.currentState!.validate();
              },
            ),
          )
        ],
      ),
    );
  }
}
