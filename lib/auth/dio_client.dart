import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'token_manager.dart';

class DioClient {
  final Dio _dio;
  final TokenManager _tokenManager;
  String? serverUrl = dotenv.env["PROJECT_API_KEY"];

  DioClient(this._tokenManager) : _dio = Dio() {
    // Interceptor 추가
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onResponse: _onResponse,
        onError: _onError,
      ),
    );
  }

  Dio get dio => _dio;

  // Request Interceptor
  Future<void> _onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Access Token 추가
    final accessToken = await _tokenManager.getAccessToken();
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options); // 다음 단계로 이동
  }

  // Response Interceptor
  Future<void> _onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    // Access Token 저장
    final accessToken = response.headers['authorization']?.first;
    if (accessToken != null) {
      await _tokenManager
          .saveAccessToken(accessToken.replaceAll('Bearer ', ''));
    }

    // Refresh Token 저장
    final setCookie = response.headers['set-cookie']?.join('; ');
    if (setCookie != null) {
      final refreshToken = _extractCookieValue(setCookie, 'refresh_token');
      if (refreshToken != null) {
        await _tokenManager.saveRefreshToken(refreshToken);
      }
    }
    handler.next(response);
  }

  // Error Interceptor
  Future<void> _onError(
      DioException error, ErrorInterceptorHandler handler) async {
    if (error.response?.statusCode == 401 ||
        error.response?.statusCode == 403) {
      // Access Token 갱신 시도
      final success = await _refreshAccessToken();

      if (success) {
        // 갱신된 토큰으로 원래 요청 재시도
        final retryOptions = error.requestOptions;
        retryOptions.headers['Authorization'] =
            'Bearer ${await _tokenManager.getAccessToken()}';

        try {
          final retryResponse = await _dio.request(
            retryOptions.path,
            options: Options(
              method: retryOptions.method,
              headers: retryOptions.headers,
            ),
            data: retryOptions.data,
            queryParameters: retryOptions.queryParameters,
          );
          return handler.resolve(retryResponse); // 재시도 응답 반환
        } catch (e) {
          print('재시도 요청 실패: $e');
          return handler.reject(error);
        }
      }
    }
    handler.reject(error); // 401/403 외의 에러는 그대로 전달
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
        // 새 Access Token 저장
        final newAccessToken = response.headers['authorization']?.first;
        if (newAccessToken != null) {
          await _tokenManager
              .saveAccessToken(newAccessToken.replaceAll('Bearer ', ''));
          return true;
        }
      }
    } catch (e) {
      print('Access Token 갱신 실패: $e');
    }
    return false;
  }

  // Set-Cookie 헤더에서 특정 쿠키 값 추출
  String? _extractCookieValue(String cookies, String cookieName) {
    final regex = RegExp('$cookieName=([^;]+);?');
    final match = regex.firstMatch(cookies);
    return match?.group(1);
  }
}
