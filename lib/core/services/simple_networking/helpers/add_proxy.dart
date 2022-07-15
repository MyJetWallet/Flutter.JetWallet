import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/dio_proxy_service.dart';

void addProxy(
  Dio dio,
) {
  final dioProxy = getIt.get<DioProxyService>();

  if (dioProxy.isProxyEnabled) {
    final clientAdapter = dio.httpClientAdapter as DefaultHttpClientAdapter;

    clientAdapter.onHttpClientCreate = (HttpClient client) {
      // Hook into the findProxy callback to set the client's proxy.
      client.findProxy = (_) {
        // proxy all request to localhost:8888
        return 'PROXY ${dioProxy.proxyName}:8888';
      };

      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      return null;
    };
  }
}
