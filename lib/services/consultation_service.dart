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

  Future<http.Response> getDiagnosis(String consultationID) async {
    final String url =
        "${Api.API_BASE_URL}/consultations/$consultationID/diagnoses";
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

  Future<http.Response> getPrescription(String consultationID) async {
    final String url =
        "${Api.API_BASE_URL}/consultations/$consultationID/prescriptions";
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

  Future<http.Response> putReminder(
      String consultationID, DateTime reminderDate, String reminderMsg) async {
    final String url =
        "${Api.API_BASE_URL}/consultations/$consultationID/reminder";
    final sessionID = await SecureStorageService().read('session_id');

    final response = await http.put(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $sessionID",
      },
      body: jsonEncode(
          {"reminder_data": reminderDate.toUtc().toIso8601String(), "reminder_message": reminderMsg}),
    );

    return response;
  }

  Future<http.Response> putPrescription(String prescriptionID) async {
    final String url =
        "${Api.API_BASE_URL}/prescriptions/$prescriptionID/purchase";
    final sessionID = await SecureStorageService().read('session_id');

    final response = await http.patch(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $sessionID",
        },
        body: jsonEncode({"purchased_at": DateTime.now().toUtc().toIso8601String()}));

    return response;
  }
}
