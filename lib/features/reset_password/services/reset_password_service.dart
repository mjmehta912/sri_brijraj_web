import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sri_brijraj_web/constants/api_constants.dart';

class ResetPasswordService {
  static Future<Map<String, dynamic>> resetPassword({
    required String username,
    required String password,
  }) async {
    final url = Uri.parse(
      '$kBaseUrl/Auth/reset',
    );

    final headers = {
      'Content-Type': 'application/json',
    };

    final requestBody = json.encode(
      {
        'username': username,
        'password': password,
      },
    );

    final response = await http.post(
      url,
      headers: headers,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      final errorData = json.decode(response.body);
      throw errorData['error'] ?? 'An unknown error occurred';
    }
  }
}
