import 'package:firebase_remote_config/firebase_remote_config.dart';
import '../../service/shared/api_urls.dart';

class RemoteConfigService {
  final config = RemoteConfig.instance;

  Future<void> overrideBaseUrls() async {
    await config.fetch();

    tradingAuthBaseUrl = config.getString('tradingAuthBaseUrl');
    walletApiBaseUrl = config.getString('walletApiBaseUrl');
    tradingBaseUrl = config.getString('tradingBaseUrl');
  }
}
