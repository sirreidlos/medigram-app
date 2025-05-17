import 'package:medigram_app/constants/api.dart';
import 'package:http/http.dart' as http;

class NonceService {
  Future<http.Response> requestNonce() async {
    final String url = "${Api.API_BASE_URL}/request-nonce";

    final response = await http.get(
      Uri.parse(url),
    );

    return response;
  }
}
