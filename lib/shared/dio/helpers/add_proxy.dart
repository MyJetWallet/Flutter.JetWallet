import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../dio_proxy_notifier/dio_proxy_notipod.dart';

void addProxy(Dio dio, Reader read) {
  final dioProxy = read(dioProxyNotipod);

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
