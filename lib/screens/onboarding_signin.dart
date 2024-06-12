import 'package:flutter/material.dart';
import 'package:morning_buddies/utils/design_palette.dart';
import 'package:morning_buddies/widgets/custom_outlined_button.dart';
import 'package:morning_buddies/widgets/form_login.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.orange,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/final_logo_orange.png',
              width: 196,
              fit: BoxFit.cover,
            ),
            // TextField
            const LoginForm(),
            // text -> link to signUp
            Align(
              alignment: Alignment.topRight,
              child: SizedBox(
                width: 280,
                child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      "아직 회원이 아니신가요?",
                      style: TextStyle(
                        color: Colors.grey,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.grey,
                        decorationThickness: 0.5,
                      ),
                    )),
              ),
            ),
            // Social login Btn
            CustomOutlinedButton(
              backgroundcolor: const Color(0xFFFEE500),
              icon: Image.asset("assets/images/kakao_logo.png"),
              width: 300,
              text: '카카오 로그인',
              textStyle: const TextStyle(color: Colors.black),
              onPressed: () {},
            ),
            CustomOutlinedButton(
              backgroundcolor: const Color(0xFFFEFEFE),
              icon: Image.asset("assets/images/google_logo.png"),
              width: 300,
              text: 'Google 로그인',
              textStyle: const TextStyle(color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
