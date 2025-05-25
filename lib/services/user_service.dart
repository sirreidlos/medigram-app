import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:medigram_app/constants/api.dart';
import 'package:medigram_app/services/secure_storage.dart';

class UserService {
  Future<http.Response> getOwnInfo() async {
    final String url = "${Api.API_BASE_URL}/me";
    final sessionID = await SecureStorageService().read('session_id');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $sessionID",
      },
    );

    return response;
  }

  Future<http.Response> getUserInfo(String userID) async {
    final String url = "${Api.API_BASE_URL}/users/$userID";
    final sessionID = await SecureStorageService().read('session_id');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $sessionID",
      },
    );

    return response;
  }

  Future<http.Response> getOwnDetail() async {
    final String url = "${Api.API_BASE_URL}/me/details";
    final sessionID = await SecureStorageService().read('session_id');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $sessionID",
      },
    );

    return response;
  }

  Future<http.Response> getUserDetail(String userID) async {
    final String url = "${Api.API_BASE_URL}/users/$userID/details";
    final sessionID = await SecureStorageService().read('session_id');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $sessionID",
      },
    );

    return response;
  }

  Future<http.Response> putOwnDetail(
    String nik,
    String name,
    DateTime dob,
    String gender,
  ) async {
    final String url = "${Api.API_BASE_URL}/me/details";
    final sessionID = await SecureStorageService().read('session_id');

    final response = await http.put(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $sessionID",
      },
      body: jsonEncode({
        "nik": nik,
        "name": name,
        "dob": dob.toIso8601String().split("T")[0],
        "gender": gender,
      }),
    );

    return response;
  }

  Future<http.Response> getOwnAllergy() async {
    final String url = "${Api.API_BASE_URL}/me/allergies";
    final sessionID = await SecureStorageService().read('session_id');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $sessionID",
      },
    );

    return response;
  }

  Future<http.Response> postOwnAllergy(String allergen, String severity) async {
    final String url = "${Api.API_BASE_URL}/me/allergies";
    final sessionID = await SecureStorageService().read('session_id');

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $sessionID",
      },
      body: jsonEncode({"allergen": allergen, "severity": severity}),
    );

    return response;
  }

  Future<http.Response> deleteAllergy(String allergyID) async {
    final String url = "${Api.API_BASE_URL}/me/allergies/$allergyID";
    final sessionID = await SecureStorageService().read('session_id');

    final response = await http.delete(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $sessionID",
      },
    );

    return response;
  }

  Future<http.Response> getOwnConditions() async {
    final String url = "${Api.API_BASE_URL}/me/medical-conditions";
    final sessionID = await SecureStorageService().read('session_id');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $sessionID",
      },
    );

    return response;
  }

  Future<http.Response> postOwnConditions(String conditions) async {
    final String url = "${Api.API_BASE_URL}/me/medical-conditions";
    final sessionID = await SecureStorageService().read('session_id');

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $sessionID",
      },
      body: jsonEncode({"conditions": conditions}),
    );

    return response;
  }

  Future<http.Response> deleteConditions(String conditionsID) async {
    final String url = "${Api.API_BASE_URL}/me/medical-conditions/$conditionsID";
    final sessionID = await SecureStorageService().read('session_id');

    final response = await http.delete(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $sessionID",
      },
    );

    return response;
  }

  Future<http.Response> getOwnMeasurements() async {
    final String url = "${Api.API_BASE_URL}/me/measurements";
    final sessionID = await SecureStorageService().read('session_id');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $sessionID",
      },
    );

    return response;
  }

  Future<http.Response> postOwnMeasurements(
    double weightInKg,
    double heightInCm,
  ) async {
    final String url = "${Api.API_BASE_URL}/me/measurements";
    final sessionID = await SecureStorageService().read('session_id');

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $sessionID",
      },
      body: jsonEncode({
        "height_in_cm": heightInCm,
        "weight_in_kg": weightInKg,
        "measured_at": DateTime.now().toIso8601String(),
      }),
    );

    return response;
  }

  Future<http.Response> getUserAllergy(String userID) async {
    final String url = "${Api.API_BASE_URL}/users/$userID/allergies";
    final sessionID = await SecureStorageService().read('session_id');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $sessionID",
      },
    );

    return response;
  }

  Future<http.Response> getUserMeasurement(String userID) async {
    final String url = "${Api.API_BASE_URL}/users/$userID/measurements";
    final sessionID = await SecureStorageService().read('session_id');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $sessionID",
      },
    );

    return response;
  }

  Future<http.Response> getUserConditions(String userID) async {
    final String url = "${Api.API_BASE_URL}/users/$userID/medical-conditions";
    final sessionID = await SecureStorageService().read('session_id');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $sessionID",
      },
    );

    return response;
  }

}
