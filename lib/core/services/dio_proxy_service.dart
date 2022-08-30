import 'package:injectable/injectable.dart';

@lazySingleton
class DioProxyService {
  String proxyName = '';

  bool get isProxyEnabled => proxyName.isNotEmpty;

  bool proxySkiped = false;

  void proxySkip() {
    proxySkiped = true;
  }

  void updateProxyName(String proxy) {
    proxyName = proxy;
  }
}
