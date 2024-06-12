import 'package:flutter/material.dart';
import 'package:morning_buddies/screens/onboarding_signUp.dart';
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
            // 메인 로고 이미지
            Image.asset(
              'assets/images/final_logo_orange.png',
              width: 196,
              fit: BoxFit.cover,
            ),
            // 이메일 ID & PW 입력 필드 및 로그인하기 버튼
            SizedBox(
              width: 300,
              child: Column(
                children: [
                  const LoginForm(),
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        // 회원가입으로 이동
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUp()),
                        );
                      },
                      child: const Text(
                        "아직 회원이 아니신가요?",
                        style: TextStyle(
                          color: Colors.grey,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.grey,
                          decorationThickness: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 회원가입으로 이동하는 textbtn

            // 소셜 로그인 버튼
            CustomOutlinedButton(
              backgroundcolor: const Color(0xFFFEE500),
              icon: Image.asset("assets/images/kakao_logo.png"),
              width: 300,
              text: '카카오 로그인',
              textStyle: const TextStyle(color: Colors.black),
              onPressed: () {
                // 카카오 로그인 로직
              },
            ),
            CustomOutlinedButton(
              backgroundcolor: const Color(0xFFFEFEFE),
              icon: Image.asset("assets/images/google_logo.png"),
              width: 300,
              text: 'Google 로그인',
              textStyle: const TextStyle(color: Colors.black),
              onPressed: () {
                // 구글 로그인 로직
              },
            ),
          ],
        ),
      ),
    );
  }
}
