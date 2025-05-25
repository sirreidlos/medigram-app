import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:medigram_app/constants/api.dart';
import 'package:medigram_app/models/consultation/post_consult.dart';
import 'package:medigram_app/services/secure_storage.dart';

class ConsultationService {
  Future<http.Response> postConsultation(
      String userID, PostConsult body) async {
    final String url = "${Api.API_BASE_URL}/users/$userID/consultations";
    final sessionID = await SecureStorageService().read('session_id');

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $sessionID",
      },
      body: jsonEncode(body),
    );
    return response;
  }

  Future<http.Response> getOwnConsultation() async {
    final String url = "${Api.API_BASE_URL}/me/consultations";
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

  Future<http.Response> getDoctorConsultation() async {
    final String url = "${Api.API_BASE_URL}/doctor/consultations";
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

  Future<http.Response> getUserConsultation(String userID) async {
    final String url = "${Api.API_BASE_URL}/users/$userID/consultations";
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

  Future<http.Response> getDiagnosis(String userID, String consultationID) async {
    final String url =
        "${Api.API_BASE_URL}/users/$userID/diagnoses/$consultationID";
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

  // Future<http.Response> getSymptom(String userID, String consultationID) async {
  //   final String url =
  //       "${Api.API_BASE_URL}/consultations/$consultationID/symptoms";
  //   final sessionID = await SecureStorageService().read('session_id');

  //   final response = await http.get(
  //     Uri.parse(url),
  //     headers: {
  //       "Content-Type": "application/json",
  //       "Authorization": "Bearer $sessionID",
  //     },
  //   );

  //   return response;
  // }

  Future<http.Response> getPrescription(String userID, String consultationID) async {
    final String url =
        "${Api.API_BASE_URL}/users/$userID/prescriptions/$consultationID";
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
