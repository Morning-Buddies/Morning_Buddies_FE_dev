import 'dart:convert';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:morning_buddies/auth/auth_gate.dart';
import 'package:morning_buddies/screens/onboarding/onboarding_signin.dart';
import 'token_manager.dart';
import '../models/user_model.dart';

class AuthController extends GetxController {
  final Rx<BEUser?> _user = Rx<BEUser?>(null);
  final _dio = Dio();
  final TokenManager _tokenManager;

  AuthController(this._tokenManager);

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
      final response = await _dio.post(url, data: {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'preferredWakeupTime': "$hour:00",
      });

      if (response.statusCode == 200) {
        print('회원가입 성공: Success Registered successfully');
        Get.offAll(const SignIn()); // 회원가입 후 로그인 화면 이동
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
      final response = await _dio.post(url, data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        // Access Token 추출
        final accessToken =
            response.headers['authorization']?.first.replaceAll('Bearer ', '');
        // Refresh Token 추출
        final setCookie = response.headers['set-cookie']?.join('; ');
        final refreshToken = setCookie != null
            ? _extractCookieValue(setCookie, 'refresh_token')
            : null;

        if (accessToken != null && refreshToken != null) {
          // 토큰 저장
          await _tokenManager.saveAccessToken(accessToken);
          await _tokenManager.saveRefreshToken(refreshToken);
          await _tokenManager.saveAccountInfo(email, password);

          // 사용자 데이터 저장
          final userData = response.data['data'];
          _user.value = BEUser.fromJson(userData);
          print(_user.value);

          // 상태 업데이트te
          _accessToken.value = accessToken;
          _refreshToken.value = refreshToken;

          print('로그인 성공: Access Token과 Refresh Token 저장');
          print('엑세스 토큰 : $accessToken');
          print('리프레시 토큰 : $refreshToken');

          Get.toNamed("/main");
        } else {
          throw Exception('Access Token 또는 Refresh Token을 찾을 수 없습니다.');
        }
      } else {
        throw Exception('로그인 요청 실패');
      }
    } on DioException catch (e) {
      print('로그인 에러: ${e.response?.data ?? e.message}');
      Get.snackbar('Error', e.response?.data['message'] ?? 'An error occurred');
    }
  }

  // 자동 로그인
  Future<void> autoLogin() async {
    print('autoLogin 호출 시작');
    Get.snackbar('자동 로그인', 'autoLogin 호출 시작');

    try {
      final email = await _tokenManager.getEmail();
      final password = await _tokenManager.getPW();
      final refreshToken = await _tokenManager.getRefreshToken();

      Get.snackbar(
        '저장된 데이터 확인',
        'Email: $email, Password: $password, Refresh Token: $refreshToken',
      );

      if (email != null && password != null) {
        Get.snackbar('자동 로그인', '저장된 이메일/비밀번호로 로그인 시도');
        await login(email, password); // 모든 조건 만족시 로그인 진행
      } else if (refreshToken != null) {
        Get.snackbar('자동 로그인', 'Refresh Token으로 세션 복원 시도');
        final success = await refreshAccessToken(refreshToken);
        if (!success) {
          Get.snackbar('로그인 실패', '세션이 만료되었습니다. 다시 로그인해주세요.');
          Get.offAll(() => const SignIn()); // 로그인 화면 이동
        }
      } else {
        Get.snackbar('자동 로그인 실패', '저장된 정보 없음, 로그인 화면으로 이동');
        Get.offAll(() => const SignIn());
      }
    } catch (e) {
      Get.snackbar('autoLogin 에러', e.toString());
      Get.offAll(() => const SignIn());
    }

    Get.snackbar('자동 로그인 완료', '로그인 상태 확인');
    print('autoLogin 완료');
  }

  // 토큰 갱신
  Future<bool> refreshAccessToken(String refreshToken) async {
    final url = "$serverUrl/auth/reissue";
    print('토큰 갱신 Refresh Token으로 새로운 엑세스 토큰 시도');

    try {
      final response = await _dio.post(
        url,
        options: Options(
          headers: {'Cookie': 'refresh_token=$refreshToken'},
        ),
      );

      if (response.statusCode == 200) {
        final newAccessToken =
            response.headers['authorization']?.first.replaceAll('Bearer ', '');
        final newRefreshToken = _extractCookieValue(
          response.headers['set-cookie']?.join('; ') ?? '',
          'refresh_token',
        );

        if (newAccessToken != null && newRefreshToken != null) {
          await _tokenManager.saveAccessToken(newAccessToken);
          await _tokenManager.saveRefreshToken(newRefreshToken);
          _accessToken.value = newAccessToken;
          _refreshToken.value = newRefreshToken;

          print('토큰 갱신 성공: 새로운 Access Token과 Refresh Token 저장');
          print(_accessToken.value);
          print(_refreshToken.value);

          return true;
        } else {
          throw Exception('새로운 토큰을 찾을 수 없습니다.');
        }
      } else {
        throw Exception('토큰 갱신 요청 실패');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        print('Refresh Token 만료 또는 유효하지 않음');
        await logout(); // 만료된 토큰 삭제 및 로그아웃 처리
      }
      return false; // 갱신 실패
    }
  }

  // 로그아웃
  Future<void> logout() async {
    await _tokenManager.deleteTokens();
    _user.value = null;
    _accessToken.value = '';
    _refreshToken.value = '';
    Get.offAll(const AuthGate());
    print('로그아웃 성공');
  }

  // 쿠키에서 특정 값 추출
  String? _extractCookieValue(String cookies, String cookieName) {
    final regex = RegExp('$cookieName=([^;]+);?');
    final match = regex.firstMatch(cookies);
    return match?.group(1);
  }
}
