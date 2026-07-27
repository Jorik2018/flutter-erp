import 'dart:convert';
import 'dart:developer' as dev;

import 'package:dio/dio.dart';
import 'package:flutter_erp/apps/wonders/logic/common/string_utils.dart';

enum NetErrorType { none, disconnected, timedOut, denied, serverError, unknown }

enum MethodType { get, post, put, patch, delete, head }

class HttpClient {
  HttpClient._();

  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
    ),
  );

  static Future<HttpResponse> get(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? urlParams,
  }) {
    return send(
      url,
      method: MethodType.get,
      headers: headers,
      urlParams: urlParams,
    );
  }

  static Future<HttpResponse> send(
    String url, {
    Map<String, dynamic>? urlParams,
    MethodType method = MethodType.post,
    Map<String, String>? headers,
    dynamic body,
    Encoding? encoding,
  }) async {
    try {
      final Response<dynamic> response = await _dio.request<dynamic>(
        url,
        queryParameters: urlParams,
        data: body,
        options: Options(
          method: _methodName(method),
          headers: headers,
          requestEncoder: encoding == null
              ? null
              : (request, options) {
                  return encoding.encode(request.toString());
                },
        ),
      );

      return HttpResponse(
        statusCode: response.statusCode ?? 0,
        body: _encodeBody(response.data),
        headers: _convertHeaders(response.headers),
      );
    } on DioException catch (e, stackTrace) {
      dev.log(
        'Network call failed: ${e.message}',
        error: e,
        stackTrace: stackTrace,
      );

      return HttpResponse(
        statusCode: e.response?.statusCode ?? 0,
        body: _encodeBody(e.response?.data),
        headers: e.response == null
            ? null
            : _convertHeaders(e.response!.headers),
        dioException: e,
      );
    } catch (e, stackTrace) {
      dev.log('Unexpected network error: $e', error: e, stackTrace: stackTrace);

      return HttpResponse(
        statusCode: 0,
        body: 'ERROR: Could not get a response',
        exception: e,
      );
    }
  }

  static String _methodName(MethodType method) {
    switch (method) {
      case MethodType.get:
        return 'GET';
      case MethodType.post:
        return 'POST';
      case MethodType.put:
        return 'PUT';
      case MethodType.patch:
        return 'PATCH';
      case MethodType.delete:
        return 'DELETE';
      case MethodType.head:
        return 'HEAD';
    }
  }

  static String? _encodeBody(dynamic data) {
    if (data == null) {
      return null;
    }

    if (data is String) {
      return data;
    }

    try {
      return jsonEncode(data);
    } catch (_) {
      return data.toString();
    }
  }

  static Map<String, String> _convertHeaders(Headers headers) {
    return headers.map.map((key, values) => MapEntry(key, values.join(',')));
  }
}

class HttpResponse {
  final int statusCode;
  final String? body;
  final Map<String, String>? headers;
  final DioException? dioException;
  final Object? exception;

  late final NetErrorType errorType;

  bool get success =>
      statusCode >= 200 && statusCode <= 299 && errorType == NetErrorType.none;

  HttpResponse({
    required this.statusCode,
    this.body,
    this.headers,
    this.dioException,
    this.exception,
  }) {
    errorType = _resolveErrorType();
  }

  NetErrorType _resolveErrorType() {
    if (dioException != null) {
      /**The type 'DioExceptionType' isn't exhaustively matched by the switch cases since it doesn't match the pattern 'DioExceptionType.transformTimeout'.
Try adding a default case or cases that match 'DioExceptionType.transformTimeout'. */
      switch (dioException!.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.transformTimeout:
          return NetErrorType.timedOut;

        case DioExceptionType.connectionError:
        case DioExceptionType.unknown:
          return NetErrorType.disconnected;

        case DioExceptionType.badResponse:
          break;

        case DioExceptionType.cancel:
        case DioExceptionType.badCertificate:
          return NetErrorType.unknown;
      }
    }

    if (statusCode >= 200 && statusCode <= 299) {
      return NetErrorType.none;
    }

    if (statusCode >= 400 && statusCode <= 499) {
      return NetErrorType.denied;
    }

    if (statusCode >= 500 && statusCode <= 599) {
      return NetErrorType.serverError;
    }

    if (statusCode == 0) {
      return NetErrorType.disconnected;
    }

    return NetErrorType.unknown;
  }
}

class ServiceResult<R> {
  final HttpResponse response;
  R? content;
  Object? parserException;

  bool get parseError => response.success && content == null;

  bool get success => response.success && !parseError;

  ServiceResult(this.response, R Function(Map<String, dynamic>) parser) {
    if (!response.success || StringUtils.isEmpty(response.body)) {
      return;
    }

    try {
      final dynamic decoded = jsonDecode(response.body!);

      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('The response body is not a JSON object');
      }

      content = parser(decoded);
    } on FormatException catch (e, stackTrace) {
      parserException = e;

      dev.log('Parse error: ${e.message}', error: e, stackTrace: stackTrace);
    } catch (e, stackTrace) {
      parserException = e;

      dev.log('Unexpected parse error: $e', error: e, stackTrace: stackTrace);
    }
  }
}
