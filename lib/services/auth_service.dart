import 'dart:convert';
import 'package:medigram_app/constants/api.dart';
import 'package:http/http.dart' as http;
import 'package:medigram_app/models/auth/login.dart';
import 'package:medigram_app/services/secure_storage.dart';

class AuthService {
  Future<http.Response> register(String email, String password) async {
    final String url = "${Api.API_BASE_URL}/register";

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
    return response;
  }

  Future<http.Response> login(String email, String password) async {
    final String url = "${Api.API_BASE_URL}/login";

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final authInfo = jsonDecode(response.body) as Map<String, dynamic>;
      final auth = Login.fromJson(authInfo);

      saveAuthData(
        accessToken: auth.accessToken,
        sessionID: auth.sessionID,
        tokenType: auth.tokenType,
        expiresIn: auth.expiresIn,
        deviceID: auth.deviceID,
        privateKey: auth.privateKey,
      );
    }

    return response;
  }

  Future<void> logout() async {
    final authData = await getAuthData();
    final deviceID = authData['device_id'];

    final String url = "${Api.API_BASE_URL}/logout";

    await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"device_id": deviceID}),
    );

    await SecureStorageService().clear();
  }

  Future<void> saveAuthData({
    required String accessToken,
    required String sessionID,
    required String tokenType,
    required int expiresIn,
    required String deviceID,
    required String privateKey,
  }) async {
    await SecureStorageService().write('access_token', accessToken);
    await SecureStorageService().write('session_id', sessionID);
    await SecureStorageService().write('token_type', tokenType);
    await SecureStorageService().write('expires_in', expiresIn.toString());
    await SecureStorageService().write('device_id', deviceID);
    await SecureStorageService().write('private_key', privateKey);
  }

  Future<Map<String, String?>> getAuthData() async {
    return {
      'access_token': await SecureStorageService().read('access_token'),
      'session_id': await SecureStorageService().read('session_id'),
      'token_type': await SecureStorageService().read('token_type'),
      'expires_in': await SecureStorageService().read('expires_in'),
      'device_id': await SecureStorageService().read('device_id'),
      'private_key': await SecureStorageService().read('private_key'),
    };
  }
}
