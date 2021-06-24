import 'package:firebase_remote_config/firebase_remote_config.dart';
import '../../service/shared/api_urls.dart';

class RemoteConfigService {
  final _config = RemoteConfig.instance;

  Future<void> overrideBaseUrls() async {
    await _config.fetch();

    tradingAuthBaseUrl = _config.getString('tradingAuthBaseUrl');
    walletApiBaseUrl = _config.getString('walletApiBaseUrl');
    tradingBaseUrl = _config.getString('tradingBaseUrl');
  }
}
