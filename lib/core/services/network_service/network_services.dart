import 'package:http/http.dart' as http;

import 'dart:convert';

class NetworkService {
  final String baseUrl = "https://api.andrespecht.dev";

  // GET Method
  Future<dynamic> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // POST Method
  Future<dynamic> post(String endpoint, {dynamic body}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
        body: body != null ? json.encode(body) : null,
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  dynamic _handleResponse(http.Response response) {
    final responseBody = response.body;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        final jsonData = json.decode(responseBody);
        return jsonData;
      } catch (e) {
        return responseBody;
      }
    } else {
      throw Exception('Request failed with status: ${response
          .statusCode}. Response: $responseBody');
    }
  }

  Map<String, String> get _headers =>
      {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
}