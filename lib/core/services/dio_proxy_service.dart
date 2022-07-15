import 'package:injectable/injectable.dart';

@lazySingleton
class DioProxyService {
  String proxyName = '';

  bool get isProxyEnabled => proxyName.isNotEmpty;

  void setProxy(String proxy) {
    proxyName = proxy;
  }
}
