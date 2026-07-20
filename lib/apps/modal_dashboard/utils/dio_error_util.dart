import 'package:dio/dio.dart';

import '../constants/strings.dart';
import 'logger.dart';

class DioErrorUtil {
  DioErrorUtil._();

  static int getErrorCode(Object error) {
    if (error is DioException) {
      return error.response?.statusCode ?? -1;
    }
    return -1;
  }

  static String getError(Object error, StackTrace stackTrace) {
    var message = Strings.somethingWentWrong;

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.cancel:
          message = Strings.requestToApiServerCancelled;
          break;

        case DioExceptionType.connectionTimeout:
          message = Strings.connectionTimeoutWithServer;
          break;

        case DioExceptionType.sendTimeout:
          message = Strings.sendTimeoutWithServer;
          break;

        case DioExceptionType.receiveTimeout:
          message = Strings.receivedTimeoutInConnectionWithServer;
          break;

        case DioExceptionType.badResponse:
          final data = error.response?.data;

          if (data is Map<String, dynamic>) {
            message = data['message']?.toString() ?? message;
          } else if (data is String && data.isNotEmpty) {
            message = data;
          }

          break;

        case DioExceptionType.connectionError:
          message = Strings.connectionTimeoutWithServer;
          break;

        case DioExceptionType.badCertificate:
          message = Strings.somethingWentWrong;
          break;

        case DioExceptionType.unknown:
        default:
          message = Strings.unexpectedErrorOccurred;
          break;
      }
    } else {
      message = Strings.unexpectedErrorOccurred;
    }

    logger.e(message, error: error, stackTrace: stackTrace);

    return message;
  }
}
