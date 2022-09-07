import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/di/di.dart';

import 'simple_networking/simple_networking.dart';

@lazySingleton
class DioProxyService {
  String proxyName = '';

  bool get isProxyEnabled => proxyName.isNotEmpty;

  bool proxySkiped = false;

  void proxySkip() {
    proxySkiped = true;

    if (isProxyEnabled) {
      getIt.get<SNetwork>().recreateDio();
    }
  }

  void updateProxyName(String proxy) {
    proxyName = proxy;
  }
}
