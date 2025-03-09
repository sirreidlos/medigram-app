import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:medigram_app/constants/api.dart';
import 'package:http/http.dart' as http;
import 'package:medigram_app/models/auth/login.dart';

class AuthService {
  final storage = FlutterSecureStorage();

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

    await storage.deleteAll();
  }

  Future<void> saveAuthData({
    required String accessToken,
    required String sessionID,
    required String tokenType,
    required int expiresIn,
    required String deviceID,
    required String privateKey,
  }) async {
    await storage.write(key: 'access_token', value: accessToken);
    await storage.write(key: 'session_id', value: sessionID);
    await storage.write(key: 'token_type', value: tokenType);
    await storage.write(key: 'expires_in', value: expiresIn.toString());
    await storage.write(key: 'device_id', value: deviceID);
    await storage.write(key: 'private_key', value: privateKey);
  }

  Future<Map<String, String?>> getAuthData() async {
    return {
      'access_token': await storage.read(key: 'access_token'),
      'session_id': await storage.read(key: 'session_id'),
      'token_type': await storage.read(key: 'token_type'),
      'expires_in': await storage.read(key: 'expires_in'),
      'device_id': await storage.read(key: 'device_id'),
      'private_key': await storage.read(key: 'private_key'),
    };
  }
}
