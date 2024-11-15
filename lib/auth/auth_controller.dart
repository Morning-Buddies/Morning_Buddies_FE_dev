import 'dart:convert';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dio_client.dart';
import 'token_manager.dart';
import '../models/user_model.dart';

class AuthController extends GetxController {
  final Rx<BEUser?> _user = Rx<BEUser?>(null);
  final DioClient _dioClient;
  final TokenManager _tokenManager;

  AuthController(this._dioClient, this._tokenManager);

  BEUser? get user => _user.value;
  bool get isLoggedIn => _user.value != null;

  String? serverUrl = dotenv.env["PROJECT_API_KEY"];

  // Login
  Future<void> login(String email, String password) async {
    final url = "$serverUrl/auth/login";

    try {
      final response = await _dioClient.dio.post(url, data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final accessToken = response.headers['authorization']?.first;
        final setCookie = response.headers['set-cookie']?.join('; ');

        if (accessToken != null && setCookie != null) {
          final refreshToken = _extractCookieValue(setCookie, 'refresh_token');
          if (refreshToken != null) {
            await _tokenManager
                .saveAccessToken(accessToken.replaceAll('Bearer ', ''));
            await _tokenManager.saveRefreshToken(refreshToken);

            final userData = response.data['data'];
            _user.value = BEUser.fromJson(userData);
            print('Success Logged in successfully, ${response.data}');
            await _tokenManager.checkAllStoredValues();
          } else {
            print('Error Failed to retrieve refresh token');
          }
        } else {
          print('Error Failed to retrieve tokens');
        }
      } else {
        Get.snackbar('Error', 'Login failed');
      }
    } on DioException catch (e) {
      print(
          '오류 발생: ${e.response?.statusCode},${e.response?.data ?? e.message}');
      Get.snackbar('Error', e.response?.data['message'] ?? 'An error occurred');
    }
  }

  // Register (no token storage required)
  Future<void> registerUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String hour,
  }) async {
    final url = "$serverUrl/auth/join";
    final dio = Dio();

    try {
      final response = await dio.post(url, data: {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'preferredWakeupTime': "$hour:00",
      });

      if (response.statusCode == 200) {
        print('회원가입 성공:Success Registered successfully');
      } else {
        print('Error Registration failed');
        print('오류 발생: ${response.statusCode},${response.data ?? response}');
      }
    } catch (e) {
      print('Error An error occurred during registration ${e}');
    }
  }

  // 쿠키 헤더에서 가져오기
  String? _extractCookieValue(String cookies, String cookieName) {
    final regex = RegExp('$cookieName=([^;]+);?');
    final match = regex.firstMatch(cookies);
    return match?.group(1);
  }

  // 로그아웃
  Future<void> logout() async {
    await _tokenManager.deleteTokens();
    _user.value = null;
    Get.snackbar('Logged out', 'You have been logged out');
  }
}
