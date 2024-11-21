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

  // 토큰 GetX 전역 관리
  final RxString _accessToken = ''.obs;
  final RxString _refreshToken = ''.obs;

  String? get accessToken => _accessToken.value;
  String? get refreshToken => _refreshToken.value;

  String? serverUrl = dotenv.env["PROJECT_API_KEY"];

  // 회원가입
  Future<void> registerUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String hour,
  }) async {
    final url = "$serverUrl/auth/join";

    try {
      final response = await _dioClient.dio.post(url, data: {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'preferredWakeupTime': "$hour:00",
      });

      if (response.statusCode == 200) {
        print('회원가입 성공: Success Registered successfully');
        // 회원가입 후 자동 로그인 -> 토큰 발급
        await login(email, password);
      } else {
        Get.snackbar('Error', 'Registration failed');
        print('Error Registration failed: ${response.data}');
      }
    } on DioException catch (e) {
      print(
          '회원가입 에러: ${e.response?.statusCode}, ${e.response?.data ?? e.message}');
      Get.snackbar('Error', e.response?.data['message'] ?? 'An error occurred');
    }
  }

  // 로그인
  Future<void> login(String email, String password) async {
    final url = "$serverUrl/auth/login";

    try {
      // 기존에 저장된 토큰 삭제
      await _tokenManager.deleteTokens();

      // 로그인 요청
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
            // 토큰 저장
            await _tokenManager
                .saveAccessToken(accessToken.replaceAll('Bearer ', ''));
            await _tokenManager.saveRefreshToken(refreshToken);

            // 상태 업데이트
            _accessToken.value = accessToken.replaceAll('Bearer ', '');
            _refreshToken.value = refreshToken;

            // 사용자 데이터 저장
            final userData = response.data['data'];
            _user.value = BEUser.fromJson(userData);

            // 디버깅용 토큰 저장 확인
            await _tokenManager.checkAllStoredValues();

            print('Logged in successfully');
          } else {
            print('Error: Failed to retrieve refresh token');
          }
        } else {
          print('Error: Failed to retrieve tokens');
        }
      } else {
        Get.snackbar('Error', 'Login failed');
      }
    } on DioException catch (e) {
      print(
          '로그인 에러: ${e.response?.statusCode}, ${e.response?.data ?? e.message}');
      Get.snackbar('Error', e.response?.data['message'] ?? 'An error occurred');
    }
  }

  // 로그아웃
  Future<void> logout() async {
    await _tokenManager.deleteTokens(); // 저장된 토큰 삭제
    // GetX 상태관리에서도 초기화
    _accessToken.value = '';
    _refreshToken.value = '';
    _user.value = null; // 사용자 상태 초기화
    Get.snackbar('Logged out', 'You have been logged out');
  }

  // 쿠키 헤더에서 특정 쿠키 추출
  String? _extractCookieValue(String cookies, String cookieName) {
    final regex = RegExp('$cookieName=([^;]+);?');
    final match = regex.firstMatch(cookies);
    return match?.group(1);
  }
}
