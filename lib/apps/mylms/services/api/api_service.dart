import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:flutter_erp/apps/mylms/config/env.dart';
import 'package:flutter_erp/apps/mylms/services/api/api_exception.dart';
import 'package:flutter_erp/apps/mylms/services/auth/auth_service.dart';

typedef JsonMap = Map<String, dynamic>;

class ApiService {
  static Map<String, String> get _headers {
    final token = AuthService.user?.token;

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<T> post<T>(
    String path,
    JsonMap data, {
    required T Function(dynamic json) fromJson,
  }) async {
    final url = Uri.parse('${Env.baseUrl}$path');

    try {
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode(data),
      );

      _validateResponse(response);

      return fromJson(jsonDecode(response.body));
    } on http.ClientException {
      throw ApiException('Network error');
    }
  }

  static Future<T> get<T>(
    String path, {
    required T Function(dynamic json) fromJson,
  }) async {
    print("GET: ${Env.baseUrl}$path");
    final url = Uri.parse('${Env.baseUrl}$path');
    try {
      final response = await http.get(url, headers: _headers);

      _validateResponse(response);

      return fromJson(jsonDecode(response.body));
    } on http.ClientException {
      throw ApiException('Network error');
    }
  }

  static void _validateResponse(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException('Request failed with status ${response.statusCode}');
    }
  }

  static Future<dynamic> fileUpload(String path, String filePath) async {
    final headres = {
      "Content-type": "multipart/form-data",
      "Accept": "application/json",
      "Authorization": "Bearer ${AuthService.user!.token}",
    };
    final url = Uri.parse("${Env.baseUrl}$path");
    try {
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll(headres);
      request.files.add(
        http.MultipartFile(
          'file',
          File(filePath).readAsBytes().asStream(),
          File(filePath).lengthSync(),
          filename: filePath.split("/").last,
        ),
      );
      final res = await request.send();
      if (res.statusCode != 200) {
        throw ApiException("Something went wrong");
      }
      return;
    } catch (e) {
      throw ApiException("Network Erorr");
    }
  }
}
