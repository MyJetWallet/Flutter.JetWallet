import 'package:dio/dio.dart';
import 'setup_headers.dart';

/// Must not depend on any providers, interceptors and other DIO.
/// Because they can break it
Future<Response> retryRequest(
  RequestOptions requestOptions,
  String token,
) async {
  final _dio = Dio();

  setupHeaders(_dio, token);

  final options = Options(
    method: requestOptions.method,
    headers: requestOptions.headers,
  );

  return _dio.request(
    requestOptions.path,
    data: requestOptions.data,
    options: options,
  );
}
