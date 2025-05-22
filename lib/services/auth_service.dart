import 'dart:convert';
import 'dart:developer' as developer;
import 'package:medigram_app/constants/api.dart';
import 'package:http/http.dart' as http;
import 'package:medigram_app/models/auth/login.dart';
import 'package:medigram_app/services/secure_storage.dart';

/// A service class that handles authentication-related operations.
/// 
/// This service provides methods for user registration, login, logout, and credential management.
/// It uses secure storage to persist authentication data between app sessions.
class AuthService {
  /// Registers a new user with the provided credentials
  /// 
  /// [email] - The user's email address
  /// [password] - The user's password
  /// Returns an HTTP response containing the registration result
  Future<http.Response> register(String email, String password) async {
    final String url = "${Api.API_BASE_URL}/register";
    developer.log('Registering user with email: $email');

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
    
    developer.log('Register response status: ${response.statusCode}');
    developer.log('Register response body: ${response.body}');
    return response;
  }

  /// Authenticates a user with the provided credentials
  /// 
  /// [email] - The user's email address
  /// [password] - The user's password
  /// Returns an HTTP response containing the authentication result
  /// If successful, stores the authentication data securely
  Future<http.Response> login(String email, String password) async {
    final String url = "${Api.API_BASE_URL}/login";
    developer.log('Attempting login to URL: $url');
    developer.log('Login request body: ${jsonEncode({"email": email, "password": password})}');

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    developer.log('Login response status: ${response.statusCode}');
    developer.log('Login response body: ${response.body}');

    if (response.statusCode == 200) {
      final authInfo = jsonDecode(response.body) as Map<String, dynamic>;
      final auth = Login.fromJson(authInfo);
      developer.log('Login successful, saving auth data');

      await saveAuthData(
        userID: auth.userID,
        sessionID: auth.sessionID,
        tokenType: auth.tokenType,
        deviceID: auth.deviceID,
        privateKey: auth.privateKey,
        email: email,
        password: password,
      );
      developer.log('Auth data saved successfully');
    } else {
      developer.log('Login failed with status code: ${response.statusCode}');
    }

    return response;
  }

  /// Logs out the current user
  /// 
  /// Sends a logout request to the server and clears all stored authentication data
  Future<void> logout() async {
    developer.log('Attempting logout');
    final deviceID = await SecureStorageService().read('device_id');
    developer.log('Device ID for logout: $deviceID');

    final String url = "${Api.API_BASE_URL}/logout";

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"device_id": deviceID}),
    );

    developer.log('Logout response status: ${response.statusCode}');
    developer.log('Logout response body: ${response.body}');

    await SecureStorageService().clear();
    developer.log('Secure storage cleared');
  }

  /// Saves authentication data to secure storage
  /// 
  /// [sessionID] - The session identifier
  /// [tokenType] - The type of authentication token
  /// [deviceID] - The device identifier
  /// [privateKey] - The private key for secure operations
  /// [email] - The user's email address
  /// [password] - The user's password
  Future<void> saveAuthData({
    required String userID,
    required String sessionID,
    required String tokenType,
    required String deviceID,
    required String privateKey,
    required String email,
    required String password,
  }) async {
    developer.log('Saving auth data - Session ID: $sessionID');
    await SecureStorageService().write('user_id', userID);
    await SecureStorageService().write('session_id', sessionID);
    await SecureStorageService().write('token_type', tokenType);
    await SecureStorageService().write('device_id', deviceID);
    await SecureStorageService().write('private_key', privateKey);
    await SecureStorageService().write('email', email);
    await SecureStorageService().write('password', password);
    developer.log('Auth data saved to storage');
  }

  /// Retrieves stored credentials from secure storage
  /// 
  /// Returns a map containing the stored email and password, or null values if not found
  Future<Map<String, String?>> getStoredCredentials() async {
    final email = await SecureStorageService().read('email');
    final password = await SecureStorageService().read('password');
    return {
      'email': email,
      'password': password,
    };
  }
}
