import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpHelper {
  static const String _baseUrl =
      //

      //    "http://localhost:8081/api/v1"; // change URL
      "https://06af-42-113-23-79.ngrok-free.app/api/v1";

  static Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await http.get(Uri.parse('$_baseUrl/$endpoint'));
    return _handleResponse(response);
  }

  // Hepler method to make a POST method
  static Future<Map<String, dynamic>> post(
      String endpoint, dynamic data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  // PUT method
  static Future<Map<String, dynamic>> put(String endpoint,
      [dynamic data]) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body:
          data != null ? json.encode(data) : null, // Chỉ mã hóa nếu có dữ liệu
    );
    return _handleResponse(response);
  }

  // PATCH method
  static Future<Map<String, dynamic>> patch(String endpoint,
      [dynamic data]) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: data != null ? json.encode(data) : null, // Encode data if provided
    );
    return _handleResponse(response);
  }

  // DELETE method
  static Future<Map<String, dynamic>> delete(String endpoint) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$endpoint'));
    return _handleResponse(response);
  }

  // Post with File
  static Future<Map<String, dynamic>> postWithFiles(
      String endpoint, dynamic fields, List<http.MultipartFile> files) async {
    var request =
        http.MultipartRequest('POST', Uri.parse('$_baseUrl/$endpoint'));
    fields.forEach((key, value) {
      request.fields[key] = value;
    });

    request.files.addAll(files);

    var response = await request.send();

    return await _handleMultipartResponse(response);
  }

  // PUT with files
  static Future<Map<String, dynamic>> putWithFiles(
      String endpoint, dynamic fields, List<http.MultipartFile> files) async {
    var request =
        http.MultipartRequest('PUT', Uri.parse('$_baseUrl/$endpoint'));

    fields.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    request.files.addAll(files);

    var response = await request.send();

    return await _handleMultipartResponse(response);
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 401 ||
        response.statusCode == 409 ||
        response.statusCode == 404) {
      return json.decode(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  // Handle response for multipart request
  static Future<Map<String, dynamic>> _handleMultipartResponse(
      http.StreamedResponse response) async {
    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseBody = await response.stream.bytesToString();
      return json.decode(responseBody);
    } else {
      final errorBody = await response.stream.bytesToString();
      print('Error Response: $errorBody'); // Print the error response body
      throw Exception('Error: ${response.statusCode}, $errorBody');
    }
  }
}
