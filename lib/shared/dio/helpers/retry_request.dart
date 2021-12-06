import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'setup_headers.dart';

/// Must not depend on any dio dependent providers, interceptors.
/// Because they can break it
Future<Response> retryRequest(
  RequestOptions requestOptions,
  Reader read,
  String token,
) async {
  final _dio = Dio();

  setupHeaders(_dio, read, token);

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
