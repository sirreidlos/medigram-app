import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:medigram_app/constants/api.dart';
import 'package:medigram_app/services/secure_storage.dart';

class DoctorService {
  Future<http.Response> getDoctor(String doctorID) async {
    final String url = "${Api.API_BASE_URL}/doctor-profile?doctor_id=$doctorID"; // TODO: Check in with backend
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
