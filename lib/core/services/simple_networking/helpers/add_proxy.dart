import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:http_proxy/http_proxy.dart';
import 'package:jetwallet/core/services/dio_proxy_service.dart';
import 'package:jetwallet/core/services/flavor_service.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:native_flutter_proxy/native_proxy_reader.dart';

Future<void> addProxy(
  Dio dio,
) async {
  final dioProxy = getIt.get<DioProxyService>();

  final flavor = flavorService();

  if (getIt<AppStore>().env == 'stage' || flavor == Flavor.stage) {
    final settings = await NativeProxyReader.proxySetting;

    if (settings.enabled) {
      await setProxy(dio, settings.host, settings.port.toString());

      return;
    }
  }

  if (dioProxy.isProxyEnabled) {
    await setProxy(dio, dioProxy.proxyName, '8888');
  }
}

Future<void> setProxy(Dio dio, String? proxyName, String? proxyPort) async {
  if (proxyName == null || proxyPort == null) return;

  final clientAdapter = dio.httpClientAdapter as DefaultHttpClientAdapter;

  clientAdapter.onHttpClientCreate = (HttpClient client) {
    // Hook into the findProxy callback to set the client's proxy.
    client.findProxy = (_) {
      // proxy all request to localhost:8888
      return 'PROXY $proxyName:$proxyPort';
    };

    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;

    return null;
  };

  HttpProxy httpProxy = await HttpProxy.createHttpProxy();
  httpProxy.host = proxyName;
  httpProxy.port = proxyPort;
  HttpOverrides.global = httpProxy;
}
