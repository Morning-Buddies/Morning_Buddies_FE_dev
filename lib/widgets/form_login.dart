import 'package:flutter/material.dart';
import 'package:morning_buddies/utils/design_palette.dart';
import 'package:morning_buddies/widgets/custom_outlined_button.dart';
import 'package:morning_buddies/widgets/custom_form_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _FormTemplateState();
}

class _FormTemplateState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController controllerId = TextEditingController();
  final TextEditingController controllerPW = TextEditingController();

  @override
  void dispose() {
    controllerId.dispose();
    controllerPW.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SizedBox(
        width: 300,
        child: Column(
          children: <Widget>[
            CustomTextFormField(
              controller: controllerId,
              hintText: 'Email or Phonenumber',
              emptyErrorText: 'Please enter some text',
            ),
            const SizedBox(height: 8),
            CustomTextFormField(
              controller: controllerPW,
              hintText: 'Password',
              emptyErrorText: 'Please enter some text',
            ),
            const SizedBox(height: 8),
            CustomOutlinedButton(
              backgroundcolor: ColorStyles.btnGrey,
              width: 300,
              text: '로그인 하기',
              textStyle: const TextStyle(color: Colors.white),
              // validate 를 통해 빈값 요청이 넘어가지 않도록 하였습니다.
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // 로그인 로직 들어갈 자리
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
