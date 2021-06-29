import 'package:firebase_remote_config/firebase_remote_config.dart';
import '../../service/shared/api_urls.dart';

class RemoteConfigService {
  final _config = RemoteConfig.instance;

  Future<void> overrideBaseUrls() async {
    await _config.fetchAndActivate();

    tradingAuthApi = _config.getString('tradingAuthApi');
    walletApi = _config.getString('walletApi');
    tradingApi = _config.getString('tradingApi');
    validationApi = _config.getString('validationApi');
  }
}
