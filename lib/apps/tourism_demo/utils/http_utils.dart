import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';

Future<Response> getRequest(String url, Map<String, String> headers) async {
  final _dio = Dio();
  Response response = await _dio.get(url, options: Options(headers: headers));
  return response;
}

Future<Response> postRequest(
  String url,
  Map<String, String> headers,
  Map<String, dynamic> body,
) async {
  final _dio = Dio();
  Response response = await _dio.post(
    url,
    data: json.encode(body),
    options: Options(headers: headers),
  );
  return response;
}
