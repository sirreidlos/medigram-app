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

      await saveAuthData(
        sessionID: auth.sessionID,
        tokenType: auth.tokenType,
        deviceID: auth.deviceID,
        privateKey: auth.privateKey,
      );
    }

    return response;
  }

  Future<void> logout() async {
    final deviceID = await SecureStorageService().read('device_id');

    final String url = "${Api.API_BASE_URL}/logout";

    await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"device_id": deviceID}),
    );

    await SecureStorageService().clear();
  }

  Future<void> saveAuthData({
    required String sessionID,
    required String tokenType,
    required String deviceID,
    required String privateKey,
  }) async {
    await SecureStorageService().write('session_id', sessionID);
    await SecureStorageService().write('token_type', tokenType);
    await SecureStorageService().write('device_id', deviceID);
    await SecureStorageService().write('private_key', privateKey);
  }
}
