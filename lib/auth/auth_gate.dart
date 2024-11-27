import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morning_buddies/auth/auth_controller.dart';
import 'package:morning_buddies/screens/onboarding/onboarding_signin.dart';
import 'package:morning_buddies/service/notification/notification_helper.dart';
import 'package:morning_buddies/widgets/home_bottom_nav.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final AuthController _authController;
  final NotificationHelper _notificationHelper = NotificationHelper();
  @override
  void initState() {
    super.initState();
    _authController = Get.find<AuthController>();
    _notificationHelper.requestPermissions();
    _notificationHelper.initializeNotifications();
    _initializeAuth(); // 자동 로그인 호출
  }

  Future<void> _initializeAuth() async {
    await _authController.autoLogin(); // 자동 로그인 시도
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_authController.user != null) {
        // 로그인 상태
        return const HomeBottomNav();
      } else {
        // 비로그인 상태
        return const SignIn();
      }
    });
  }
}
