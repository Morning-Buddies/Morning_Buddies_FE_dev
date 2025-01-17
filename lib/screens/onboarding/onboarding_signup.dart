import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:morning_buddies/screens/signup_getuserinfo.dart';
import 'package:morning_buddies/utils/design_palette.dart';
import 'package:morning_buddies/widgets/button/custom_outlined_button.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: ColorStyles.orange,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 메인 이미지 로고
            MainLogo(),
            // 이메일 회원가입 버튼 및 로그인화면으로 돌아가기 텍스트버튼
            SignUpButtons(),
          ],
        ),
      ),
    );
  }
}

class MainLogo extends StatelessWidget {
  const MainLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/final_logo_orange.png',
      width: 196,
      fit: BoxFit.cover,
    );
  }
}

class SignUpButtons extends StatelessWidget {
  const SignUpButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Column(
        children: [
          CustomOutlinedButton(
            backgroundcolor: ColorStyles.btnGrey,
            width: 300,
            text: '이메일로 회원가입',
            textStyle: const TextStyle(color: Colors.white),
            onPressed: () => Get.to(const GetUserInfoScrceen()),
          ),
          Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "로그인으로 돌아가기",
                style: TextStyle(
                  color: Colors.grey,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.grey,
                  decorationThickness: 0.5,
                ),
              ),
            ),
          ),
          const KakaoLoginButton(),
          const GoogleLoginButton(),
        ],
      ),
    );
  }
}

class KakaoLoginButton extends StatelessWidget {
  const KakaoLoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomOutlinedButton(
      backgroundcolor: const Color(0xFFFEE500),
      icon: Image.asset("assets/images/kakao_logo.png"),
      width: 300,
      text: '카카오 로그인',
      textStyle: const TextStyle(color: Colors.black),
      onPressed: () {
        // 카카오 로그인 로직
      },
    );
  }
}

class GoogleLoginButton extends StatelessWidget {
  const GoogleLoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomOutlinedButton(
      backgroundcolor: const Color(0xFFFEFEFE),
      icon: Image.asset("assets/images/google_logo.png"),
      width: 300,
      text: 'Google 로그인',
      textStyle: const TextStyle(color: Colors.black),
      onPressed: () {
        // 구글 로그인 로직
      },
    );
  }
}
