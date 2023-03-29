import 'package:dio/dio.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:logger/logger.dart' as logPrint;

import 'setup_headers.dart';

/// Must not depend on any dio dependent providers, interceptors.
/// Because they can break it
Future<Response> retryRequest(
  RequestOptions requestOptions,
) async {
  final _dio = Dio();

  final log = logPrint.Logger();

  requestOptions = await setHeaders(requestOptions, false);

  final options = Options(
    method: requestOptions.method,
    headers: requestOptions.headers,
  );

  final authModel = getIt.get<AppStore>().authState;
  if (authModel.token.isNotEmpty) {
    options.headers!['Authorization'] = 'Bearer ${authModel.token}';
  }

  log.i(
    'RETRY OPTIONS: ${options.headers}\nStore token: ${authModel.token}',
  );

  return _dio.request(
    requestOptions.path,
    data: requestOptions.data,
    options: options,
  );
}
