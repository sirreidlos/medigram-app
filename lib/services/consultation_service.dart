import 'package:http/http.dart' as http;
import 'package:medigram_app/constants/api.dart';
import 'package:medigram_app/models/consultation/post_consult.dart';
import 'package:medigram_app/services/secure_storage.dart';

class ConsultationService {
  Future<http.Response> postConsultation(PostConsult body) async {
    final String url = "${Api.API_BASE_URL}/consultation";

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: body.toJson(),
    );
    return response;
  }

  Future<http.Response> getConsultation() async {
    final String url = "${Api.API_BASE_URL}/consultation";
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
    final String url = "${Api.API_BASE_URL}/diagnoses/$consultationID"; 
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

  Future<http.Response> getSymptom(String consultationID) async {
    final String url = "${Api.API_BASE_URL}/symptom/$consultationID";
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
    final String url = "${Api.API_BASE_URL}/prescription/$consultationID"; 
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
