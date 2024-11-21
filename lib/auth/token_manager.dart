import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager {
  static final TokenManager _instance = TokenManager._internal();

  TokenManager._internal();

  factory TokenManager() {
    return _instance;
  }

  final _storage = const FlutterSecureStorage();

  Future<void> saveAccessToken(String accessToken) async {
    await _storage.write(key: 'accessToken', value: accessToken);
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    await _storage.write(key: 'refreshToken', value: refreshToken);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'accessToken');
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refreshToken');
  }

  Future<void> deleteTokens() async {
    await _storage.delete(key: 'accessToken');
    await _storage.delete(key: 'refreshToken');
    print("Deleted all tokens");
  }

  Future<Map<String, String>> getAllTokens() async {
    final accessToken = await _storage.read(key: 'accessToken') ?? '';
    final refreshToken = await _storage.read(key: 'refreshToken') ?? '';
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }

  Future<void> checkAllStoredValues() async {
    Map<String, String> allValues = await _storage.readAll();
    allValues.forEach((key, value) {
      print('$key: $value');
    });
  }
}
