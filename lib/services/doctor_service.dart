import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:medigram_app/constants/api.dart';
import 'package:medigram_app/services/secure_storage.dart';

class DoctorService {
  Future<http.Response> getDoctorByID(String doctorID) async {
    final String url = "${Api.API_BASE_URL}/doctors/$doctorID/profile";
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

  Future<http.Response> getDoctorByUserID(String userID) async {
    final String url = "${Api.API_BASE_URL}/users/$userID/doctor-profile";
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

  Future<http.Response> postOwnDoctor() async {
    final String url = "${Api.API_BASE_URL}/me/doctor-profile";
    final sessionID = await SecureStorageService().read('session_id');

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $sessionID",
      },
    );

    return response;
  }

  Future<http.Response> postOwnPractice(String permit, String address) async {
    final String url = "${Api.API_BASE_URL}/doctor/practice-location";
    final sessionID = await SecureStorageService().read('session_id');

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $sessionID",
      },
      body: jsonEncode({"practice_permit": permit, "practice_address": address}),
    );

    return response;
  }

}
