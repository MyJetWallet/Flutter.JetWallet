import 'package:dio/dio.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:logger/logger.dart' as log_print;

import 'setup_headers.dart';

/// Must not depend on any dio dependent providers, interceptors.
/// Because they can break it
Future<Response> retryRequest(
  RequestOptions requestOptions,
) async {
  final dio = Dio();

  final log = log_print.Logger();

  final tempRequestOptions = await setHeaders(requestOptions, false);

  final options = Options(
    method: tempRequestOptions.method,
    headers: tempRequestOptions.headers,
  );

  final authModel = getIt.get<AppStore>().authState;
  if (authModel.token.isNotEmpty) {
    options.headers!['Authorization'] = 'Bearer ${authModel.token}';
  }

  log.i(
    'RETRY OPTIONS: ${options.headers}\nStore token: ${authModel.token}',
  );

  return dio.request(
    tempRequestOptions.path,
    data: tempRequestOptions.data,
    options: options,
  );
}
