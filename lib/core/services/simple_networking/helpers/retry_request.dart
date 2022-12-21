import 'package:dio/dio.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/features/app/store/app_store.dart';

import 'setup_headers.dart';

/// Must not depend on any dio dependent providers, interceptors.
/// Because they can break it
Future<Response> retryRequest(
  RequestOptions requestOptions,
) async {
  final _dio = Dio();

  requestOptions = setHeaders(requestOptions, false);

  final options = Options(
    method: requestOptions.method,
    headers: requestOptions.headers,
  );

  final authModel = getIt.get<AppStore>().authState;
  if (authModel.token.isNotEmpty) {
    _dio.options.headers['Authorization'] = 'Bearer ${authModel.token}';
  }

  return _dio.request(
    requestOptions.path,
    data: requestOptions.data,
    options: options,
  );
}
