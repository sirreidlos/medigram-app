import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:medigram_app/constants/api.dart';
import 'package:medigram_app/constants/style.dart';
import 'package:medigram_app/models/user/user.dart';
import 'package:medigram_app/services/secure_storage.dart';

class UserService {
  Future<http.Response> getUser() async {
    final String url = "${Api.API_BASE_URL}/user";
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

  Future<http.Response> getUserDetail() async {
    final String url = "${Api.API_BASE_URL}/user-detail";
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

  Future<http.Response> putUserDetail(
    String nik,
    String name,
    DateTime dob,
    String gender,
  ) async {
    final String url = "${Api.API_BASE_URL}/user-detail";
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

  Future<http.Response> getAllergy() async {
    final String url = "${Api.API_BASE_URL}/allergy";
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

  Future<http.Response> postAllergy(String allergen, String severity) async {
    final String url = "${Api.API_BASE_URL}/allergy";
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
    final String url = "${Api.API_BASE_URL}/allergy";
    final sessionID = await SecureStorageService().read('session_id');

    final response = await http.delete(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $sessionID",
      },
      body: jsonEncode({"allergy_id": allergyID}),
    );

    return response;
  }

  Future<http.Response> getMeasure() async {
    final String url = "${Api.API_BASE_URL}/user-measurement";
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

  Future<http.Response> postMeasure(
    double weightInKg,
    double heightInCm,
  ) async {
    final String url = "${Api.API_BASE_URL}/user-measurement";
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
}
