import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'token_manager.dart';

// Login 시에만 활용하는 Intercepter
class DioClient {
  final Dio _dio;
  final TokenManager _tokenManager;
  String? serverUrl = dotenv.env["PROJECT_API_KEY"];

  DioClient(this._tokenManager) : _dio = Dio() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // 모든 요청에 Access Token 추가 (있을 경우)
        final accessToken = await _tokenManager.getAccessToken();
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }

        // Refresh Token은 자동 갱신 로직에만 필요하므로 요청 시에는 추가하지 않음
        return handler.next(options);
      },
      onResponse: (response, handler) async {
        // 응답에서 Access Token과 Refresh Token 추출해 저장 (로그인 시 사용)
        final accessToken = response.headers['authorization']?.first;
        final setCookie = response.headers['set-cookie']?.join('; ');

        if (accessToken != null) {
          await _tokenManager
              .saveAccessToken(accessToken.replaceAll('Bearer ', ''));
        }

        if (setCookie != null) {
          final refreshToken = _extractCookieValue(setCookie, 'refresh_token');
          if (refreshToken != null) {
            await _tokenManager.saveRefreshToken(refreshToken);
          }
        }

        return handler.next(response);
      },
      onError: (error, handler) async {
        // Access Token 만료 시 Refresh Token으로 새 토큰 발급
        if (error.response?.statusCode == 403) {
          final success = await _refreshAccessToken();
          if (success) {
            // 토큰 갱신 성공 시 원래 요청 재시도
            final retryOptions = error.requestOptions;
            retryOptions.headers['Authorization'] =
                'Bearer ${await _tokenManager.getAccessToken()}';
            final retryResponse = await _dio.request(
              retryOptions.path,
              options: Options(
                method: retryOptions.method,
                headers: retryOptions.headers,
              ),
              data: retryOptions.data,
              queryParameters: retryOptions.queryParameters,
            );
            return handler.resolve(retryResponse);
          }
        }
        return handler.reject(error);
      },
    ));
  }

  Dio get dio => _dio;

  // Set-Cookie 헤더에서 특정 쿠키 값 추출
  String? _extractCookieValue(String cookies, String cookieName) {
    final regex = RegExp('$cookieName=([^;]+);?');
    final match = regex.firstMatch(cookies);
    return match?.group(1);
  }

  // Refresh Token을 사용해 Access Token 갱신
  Future<bool> _refreshAccessToken() async {
    try {
      final refreshToken = await _tokenManager.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await _dio.post(
        '$serverUrl/auth/reissue',
        options: Options(
          headers: {
            'Cookie': 'refresh_token=$refreshToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        // 새로 발급된 Access Token 저장
        final newAccessToken = response.headers['authorization']?.first;
        if (newAccessToken != null) {
          await _tokenManager
              .saveAccessToken(newAccessToken.replaceAll('Bearer ', ''));
          return true;
        }
      }
    } catch (e) {
      print('토큰 갱신 실패: $e');
    }
    return false;
  }
}
