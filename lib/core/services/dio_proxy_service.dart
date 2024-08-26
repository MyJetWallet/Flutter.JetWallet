import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/features/app/store/app_store.dart';

import 'simple_networking/simple_networking.dart';

@lazySingleton
class DioProxyService {
  String proxyName = '';

  bool get isProxyEnabled => proxyName.isNotEmpty;

  bool proxySkiped = false;

  void proxySkip() {
    proxySkiped = true;

    if (isProxyEnabled) {
      getIt.get<SNetwork>().init(getIt<AppStore>().sessionID);
    }
  }

  void updateProxyName(String proxy) {
    proxyName = proxy;
  }
}