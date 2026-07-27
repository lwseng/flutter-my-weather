// services/api_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  Future<Map<String, dynamic>> get(String url) async {
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Request failed with status ${response.statusCode}');
    }

    return json.decode(response.body);
  }
}