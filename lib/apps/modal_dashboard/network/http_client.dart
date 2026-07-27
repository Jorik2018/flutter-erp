import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

final List<int> successRange = List<int>.generate(100, (index) => index + 200);

final BaseOptions _baseOptions = BaseOptions(
  baseUrl: 'http://api.test',
  receiveTimeout: const Duration(seconds: 5),
  connectTimeout: const Duration(seconds: 5),
  sendTimeout: const Duration(seconds: 5),

  // Opcional: considerar éxito cualquier código 2xx.
  validateStatus: (status) {
    return status != null && successRange.contains(status);
  },
);

final CookieJar cookieJar = CookieJar();

final Dio dio = Dio(_baseOptions)
  ..interceptors.add(CookieManager(cookieJar))
  ..interceptors.add(
    InterceptorsWrapper(
      onRequest:
          (RequestOptions options, RequestInterceptorHandler handler) async {
            await _doSomethingBeforeMakingHttpRequest(options);

            handler.next(options);
          },
      onResponse:
          (Response<dynamic> response, ResponseInterceptorHandler handler) {
            handler.next(response);
          },
      onError: (DioException error, ErrorInterceptorHandler handler) {
        handler.next(error);
      },
    ),
  );

Future<void> _doSomethingBeforeMakingHttpRequest(RequestOptions options) async {
  // Ejemplos:
  options.headers['Accept'] = 'application/json';

  // Podrías obtener un token de almacenamiento:
  // final token = await secureStorage.read(key: 'token');
  // if (token != null) {
  //   options.headers['Authorization'] = 'Bearer $token';
  // }
}
