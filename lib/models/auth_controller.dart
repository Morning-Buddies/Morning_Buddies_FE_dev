import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:morning_buddies/models/UserModel.dart';

class AuthController extends GetxController {
  final Rx<BEUser?> _user = Rx<BEUser?>(null);
  final Dio _dio = Dio();

  BEUser? get user => _user.value;
  bool get isLoggedIn => _user.value != null;

  String? serverUrl = dotenv.env["PROJECT_API_KEY"];

  Future<void> login(String email, String password) async {
    final url = "$serverUrl/auth/login";

    try {
      final response = await _dio.post(url, data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final userData = response.data['data'];
        _user.value = BEUser.fromJson(userData);
        print('로그인 성공: ${response.data}');

        // 토큰 저장 등 추가 처리 가능
        Get.snackbar('Success', 'Logged in successfully');
      } else {
        print('로그인 실패: ${response.statusCode} - ${response.data}');
        Get.snackbar('Error', 'Login failed');
      }
    } on DioException catch (e) {
      print('오류 발생: ${e.response?.data ?? e.message}');
      Get.snackbar('Error', e.response?.data['message'] ?? 'An error occurred');
    }
  }

  // DIO 패키지를 이용한 회원가입 요청
  Future<void> registerUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String hour,
  }) async {
    if (serverUrl == null || serverUrl!.isEmpty) {
      print("Error: PROJECT_API_KEY is not set in .env file");
      return;
    }

    final url = "$serverUrl/auth/join";

    try {
      final requestBody = {
        "email": email,
        "password": password,
        "firstName": firstName,
        "lastName": lastName,
        "preferredWakeupTime": "$hour:00", // 08 형식으로 보내야함
        "phoneNumber": phoneNumber,
      };

      print("Sending request to: $url");
      print("Request body: ${jsonEncode(requestBody)}");

      final response = await _dio.post(
        url,
        options: Options(
          headers: {"Content-Type": "application/json"},
          validateStatus: (status) => status! < 500,
        ),
        data: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print('회원가입 성공: ${response.data}');
      } else {
        print('회원가입 실패: ${response.statusCode} - ${response.data}');
      }
    } on DioException catch (e) {
      print(e.response!.data.toString());
      if (e.response != null) {
        print('회원가입 실패: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        print('오류 발생: ${e.message}');
      }
    } catch (error) {
      print('오류 발생: $error');
    }
  }

  void logout() {
    _user.value = null;
    Get.snackbar('Logged out', 'You have been logged out');
  }
}
